# -*- coding: utf-8 -*-
require "regicide/mutator/stack_frame"
require "regicide/mutator/frame_slot"
require "regicide/mutator/object_value"
require "regicide/mutator/null_value"

module Regicide
  class Mutator
    attr_accessor :out_of_memory, :context

    @@mutator_id = 0
    @@mutators = ThreadSafe::Hash.new

    def initialize
      @monitor = ::Monitor.new
      @context = create_mutator_context
      @out_of_memory = false
      @monitor.synchronize{
        @@mutator_id += 1
        @mutator_id = @@mutator_id
      }
      @@mutators[@@mutator_id] = self
      @context.init_mutator(@mutator_id)
      @stack = []
    end

    def out_of_memory?
      @out_of_memory
    end

    def prologue
    end

    def epilogue
      @@mutators.delete(@@mutator_id)
    end

    def stack_push(frame)
      @stack << frame
    end

    def stack_pop
      @stack.pop
    end

    def current_stack
      @stack[-1]
    end

    def gc_safe_point
      if Scheduler.instance.gc_triggerd?
        Scheduler.instance.wait_for_gc
        return true
      end
      return false
    end

    def roots
      return @stack.inject([]){|r, frame| r.concat(frame.roots) }
    end

    def compute_thread_roots(trace)
      @stack.each{|frame| frame.compute_roots(trace) }
    end

    def store_data_field(object, index, value)
      check_null_object(object)
      check_data_index_in_range(object, index)
      ref = ObjectModel.data_slot(object, index)
      if ActivePlan.constraints.needs_int_write_barrier
        @context.in_wirte(object, ref, value,
          ref.to_word, nil, Plan::INSTANCE_FIELD)
      else
        ref.store(value)
      end
    end

    def store_reference_field(object, index, value)
      check_null_object(object)
      check_ref_index_in_range(object, index)
      ref = ObjectModel.ref_slot(object, index)
      if ActivePlan.constraints.needs_object_reference_write_barrier
        @context.object_reference_write(object, ref, value,
          ref.to_word, nil, Plan::INSTANCE_FIELD)
      else
        ref.store(value)
      end
    end

    def load_data_field(object, index)
      check_null_object(object)
      check_data_index_in_range(object, index)
      data = ObjectModel.data_slot(object, index)
      if ActivePlan.constraints.needs_int_read_barrier
        res = @context.int_read(object, data,
                data.to_word, nil, Plan::INSTANCE_FIELD)
      else
        res = data.load_int
      end
      return res
    end

    def load_reference_field(object, index)
      check_null_object(object)
      check_ref_index_in_range(object, index)
      ref = ObjectModel.ref_slot(object, index)
      if ActivePlan.constraints.needs_object_reference_read_barrier
        res = @context.object_reference_read(object, ref,
                ref.to_word, nil, Plan::INSTANCE_FIELD)
      else
        res = ref.load_object_reference
      end
      return res
    end

    def hash(object)
      check_null_object(object)
      return ObjectModel.hash_code(object)
    end

    def alloc(ref_count, data_count, alloc_site)
      if not (0..ObjectModel::MAX_REF_FIELDS).include?(ref_count)
        fail "ref_count(#{ref_count}) is out of range."
      end
      if not (0..ObjectModel::MAX_DATA_FIELDS).include?(data_count)
        fail "data_count(#{data_count}) is out of range."
      end
      res = ObjectModel.allocateObject(
              @context, ref_count, data_count, alloc_site)
      fail "Allocation returned nil" if res.nil?
      return res
    end

    def site_name(object)
      return ObjectModel.site(object)
    end

    def self.mutators
      @@mutators
    end

    private
    def create_mutator_context
      prefix = java.lang.System.get_property(
                 "mmtk.regicide.plan",
                 "org.mmtk.plan.marksweep.MS")
      return eval("#{prefix}Mutator.new")
    end

    def check_ref_index_in_range(object, index)
      limit = ObjectModel.ref_count(object)
      unless (0..limit).include?(index)
        fail "Invalid ref index #{index}: limit is #{limit}"
      end
    end

    def check_data_index_in_range(object, index)
      limit = ObjectModel.data_count(object)
      unless (0..limit).include?(index)
        fail "Invalid data index #{index}: limit is #{limit}"
      end
    end

    def check_null_object(object)
      if object.null?
        fail "Object can not be null in object #{ObjectModel.string(object)}"
      end
    end
  end
end
