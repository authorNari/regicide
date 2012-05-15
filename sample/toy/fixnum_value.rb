module Toy
  class FixnumValue < Regicide::Mutator::ObjectValue
    def to_i(mutator)
      mutator.load_data_field(@value, 0)
    end

    def self.from_i(mutator, fixnum)
      v = self.new(mutator.alloc(0, 1, mutator.current_stack.pc))
      mutator.store_data_field(v.object_value, 0,
        org.vmmagic.unboxed.Word.from_long(fixnum))
      return v
    end
  end
end
