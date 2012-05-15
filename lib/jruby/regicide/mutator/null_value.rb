require "singleton"

module Regicide
  class Mutator
    class NullValue < ObjectValue
      include Singleton

      def initialize
        super ObjectReference.null_reference
      end

      def bool_value
        return false
      end

      def ==(other)
        return self == other
      end
    end

    class ObjectValue
      NULL = NullValue.instance

      def self.initial_value
        NULL
      end
    end
  end
end

