module Regicide
  class Barriers < org.mmtk.vm.Barriers
    private
    def self.define_typed_accessor(type)
      define_method("#{type}Write") do |ref, vlaue, slot, unused, mode|
        slot.to_address.store(value)
      end
      define_method("#{type}Read") do |ref, slot, unused, mode|
        method = "load_"
        method += type.gsub(/[A-Z]/){|m| "_" + m.downcase}
        slot.to_address.send(method)
      end
    end

    def self.define_typed_cas(type)
      define_method("#{type}TryCompareAndSwap") do |ref, old, vlaue, slot, unused, mode|
        return slot.to_address.attempt(old, value)
      end
    end

    public
    def booleanWrite(ref, value, slot, unused, mode)
      slot.to_address.store(value ? 1 : 0)
    end

    def booleanRead(ref, slot, unused, mode)
      return slot.to_address.load_byte != 0
    end

    def objectReferenceNonHeapWrite(slot, tg, unusedA, unusedB)
      slot.store(tg)
    end

    def objectArrayStoreNoGCBarrier(dst, index, value)
      dst[index] = value
    end

    def objectReferenceAtomicWrite(ref, tg, slot, unused, mode)
      old = slot.to_address.prepare_object_reference
      until slot.to_address.attempt(old, tg)
        old = slot.to_address.prepare_object_reference
      end
      return old
    end

    def wordAtomicWrite(ref, target, slot, unused, mode)
      old = slot.to_address.prepare_word
      until slot.to_address.attempt(old, target)
        old = slot.to_address.prepare_word
      end
      return old
    end

    define_typed_accessor :byte
    define_typed_accessor :char
    define_typed_accessor :short
    define_typed_accessor :int
    define_typed_accessor :long
    define_typed_accessor :float
    define_typed_accessor :double
    define_typed_accessor :objectReference
    define_typed_accessor :word
    define_typed_accessor :address
    define_typed_accessor :offset
    define_typed_accessor :extent

    define_typed_cas :int
    define_typed_cas :long
    define_typed_cas :objectReference
    define_typed_cas :word
    define_typed_cas :address
    define_typed_cas :offset
    define_typed_cas :extent
  end
end
