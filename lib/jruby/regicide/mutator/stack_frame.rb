module Regicide
  class Mutator
    # A stack frame.
    class StackFrame
      attr_accessor :pc, :code

      # Create a stack frame, given a list of declarations and a
      # quantity of temporaries.
      def initialize
        @values = []
        @pc = 0
        @code = []
      end


      def [](slot)
        return @values[slot]
      end

      def []=(slot, stack_value)
        return @values[slot] = stack_value
      end

      def pop
        @values.pop
      end

      def push(value)
        @values.push(value)
      end

      def compute_roots(trace)
        cnt = roots.inject(0) do |r, obj|
          if obj.object_value.is_a?(ObjectReference) && !obj.object_value.null?
            obj.trace_object(trace)
            r += 1
          end
          r
        end
      end

      def roots
        return @values
      end

      def clear_result_slot
        @result_slot = NO_SUCH_SLOT
      end
    end
  end
end
