module Regicide
  class Scheduler
    class Monitor < org.mmtk.vm.Monitor
      TRACE = false
      def initialize(name)
        super()
        @name = name
        @monitor = java.lang.Object.new
        @is_locked = false
      end
      attr_accessor :name

      def await
        puts "await(): in #{@name}" if TRACE
        @monitor.synchronized do
          unlock
          @monitor.wait
          lock
        end
        puts "await(): out #{@name}" if TRACE
      end

      def broadcast
        puts "broadcast: in #{@name}" if TRACE
        @monitor.synchronized do
          @monitor.notify_all
        end
        puts "broadcast: out #{@name}" if TRACE
      end
      
      def lock
        puts "lock: in #{@name}" if TRACE
        @monitor.synchronized do
          while(@is_locked) do
            @monitor.wait rescue nil
          end
          @is_locked = true
        end
        puts "lock: out #{@name}" if TRACE
      end

      def unlock
        puts "unlock: in #{@name}" if TRACE
        @monitor.synchronized do
          @is_locked = false
          @monitor.notify_all
        end
        puts "unlock: out #{@name}" if TRACE
      end
    end
  end
end
