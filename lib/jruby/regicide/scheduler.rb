require "monitor"
require "thread_safe"
require 'singleton'
require "regicide/scheduler/mutator_thread"
require "regicide/scheduler/collector_thread"
require "regicide/scheduler/lock"
require "regicide/scheduler/monitor"
require "regicide/mutator"

module Regicide
  class Scheduler
    include Singleton

    attr_reader :mutators, :collectors

    def initialize
      @collectors = ThreadSafe::Hash.new
      @mutators = ThreadSafe::Hash.new
      @state = :mutator # :mutator / :bloking / :blocked
      @running = false
      @gc_trigger = ::Monitor.new
      @gc_trigger_cond = @gc_trigger.new_cond
      @count_monitor = ::Monitor.new
      @count_monitor_cond = @count_monitor.new_cond
      @blocked_mutators = 0
      @active_mutators = 0
    end

    def yield
      Thread.pass if @running
    end

    def schedule_mutator(&proc)
      th = MutatorThread.new(self, proc)
      @mutators[th] = th
    end

    def add_active_mutator(th)
      @count_monitor.synchronize do
        if not all_waiting_for_gc?
          inc_active_mutators
          return
        end
        @blocked_mutators+=1
        inc_active_mutators
      end
      wait_for_gc
      @count_monitor.synchronize do
        @blocked_mutators-=1
      end
    end

    def delete_active_mutator(th)
      @count_monitor.synchronize do
        last_to_gc = (@blocked_mutators == (@active_mutators - 1))
        if (@active_mutators == 1 || !last_to_gc)
          dec_active_mutators
          @mutators.delete(th)
          return
        end
        @blocked_mutators+=1
      end
      wait_for_gc
      @count_monitor.synchronize do
        @blocked_mutators-=1
        dec_active_mutators
      end
      @mutators.delete(th)
    end

    def schedule_collector(context)
      CollectorThread.new(self, context)
    end

    def add_active_collector(th)
      @collectors[th] = th
      th.context.init_collector(@collectors.size)
    end

    def delete_active_collector(th)
      @collectors.delete(th)
    end

    def self.current_log
      Thread.current[:log] ||= org.mmtk.utility.Log.new
      return Thread.current[:log]
    end

    def current_mutator
      if not mutator?
        raise "Current thread isn't mutator"
      end
      return Thread.current.mutator
    end

    def current_collector
      if not collector?
        raise "Current thread isn't collector"
      end
      return Thread.current.context
    end

    def gc_triggerd?
      return state != :mutator
    end

    def wait_for_gc
      last = false
      @count_monitor.synchronize do 
        @blocked_mutators += 1
        last = all_waiting_for_gc?
      end
      @gc_trigger.synchronize do
        @gc_trigger_cond.wait_while{ @state == :mutator }
        if last
          @state = :blocked
          @gc_trigger_cond.broadcast
        end
        @gc_trigger_cond.wait_while{ [:blocking, :blocked].include?(@state) }
      end
      @count_monitor.synchronize do 
        @blocked_mutators -= 1
      end
    end

    def schedule
      @running = true
      @count_monitor.synchronize do
        @count_monitor_cond.wait_while{ @mutators.size > @active_mutators }
      end
      @count_monitor.synchronize do
        @count_monitor_cond.wait_while{ @active_mutators > 0 }
      end
    end

    def new_lock(name)
      return Lock.new(name)
    end

    def new_monitor(name)
      return Monitor.new(name)
    end

    def stop_all_mutators
      @gc_trigger.synchronize do
        @state = :blocking
        @gc_trigger_cond.broadcast
      end
      wait_for_gc_start
    end

    def resume_all_mutators
      @gc_trigger.synchronize do
        @state = :mutator
        @gc_trigger_cond.broadcast
      end
    end

    def mutator?
      Thread.current.is_a?(MutatorThread)
    end

    def collector?
      Thread.current.is_a?(CollectorThread)
    end

    private
    def all_waiting_for_gc?
      (@active_mutators > 0) && (@blocked_mutators == @active_mutators)
    end

    def inc_active_mutators
      @active_mutators+=1
      @count_monitor_cond.broadcast
    end

    def dec_active_mutators
      @active_mutators-=1
      if @active_mutators == 0
        @count_monitor_cond.broadcast
      end
    end

    def wait_for_gc_start
      @gc_trigger.synchronize do
        @gc_trigger_cond.wait_while{ @state != :blocked }
      end
    end
  end
end
