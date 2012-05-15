module Toy
  class BoolValue < Regicide::Mutator::ObjectValue
    def initialize(value)
      @value = value
    end
  end
end
