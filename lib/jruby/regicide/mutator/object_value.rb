module Regicide
  class Mutator
    class ObjectValue
      @@current_root_discovery_phase = 1
      @@lock = java.lang.Object.new

      def self.object?
        return true
      end

      def self.compatible_with?(other)
        return true if other == self
        return true if other.object?
        return false
      end

      def self.start_root_discovery_phase
        @@lock.synchronized { @@current_root_discovery_phase+=1 }
      end

      def initialize(value = ObjectReference.null_reference)
        @value = value
        @last_discovery_phase = 0
      end

      def object_value
        @value
      end

      def bool_value
        !@value.null?
      end

      def to_s
        return "null" if @value.null?
        return @value.to_s
      end

      def trace_object(trace)
        if @last_discovery_phase < @@current_root_discovery_phase
          value = trace.trace_object(@value, true)
          @last_discovery_phase = @@current_root_discovery_phase
        end
      end

      def marshall(klass)
        if klass.is_a?(self.class)
          return self
        end
        raise "Can't marshall an object into a Java Object"
      end

      def ==(other)
        other.is_a?(ObjectValue) && @value.equals(other.object_value)
      end

      def hash_code
        @value.hash_code
      end
    end
  end
end
