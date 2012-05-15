module Regicide
  class Mutator
    class FrameSlot
      def initialize(name, type, index, value)
        @name = name
        @type = type
        @index = index
        @value = value
      end
      attr_reader :name, :type, :index
      attr_accessor :value
    end
  end
end
