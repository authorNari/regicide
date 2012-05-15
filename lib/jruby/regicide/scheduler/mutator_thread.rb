module Regicide
  class Scheduler
    class MutatorThread < Thread
      attr_reader :mutator

      def initialize(scheduler, proc)
        @scheduler = scheduler
        @proc = proc
        @mutator = Mutator.new
        super do
          begin
            @mutator.prologue
            prologue
            proc.call(@mutator)
          rescue => ex
            $stderr.puts("#{self} : #{ex}")
            ex.backtrace.each do |line|
              $stderr.puts(line)
            end
          ensure
            epilogue
            @mutator.epilogue
          end
        end
      end

      def prologue
        @scheduler.add_active_mutator(self)
      end

      def epilogue
        @scheduler.delete_active_mutator(self)
      end
    end
  end
end
