module Regicide

  # A Lang implementation of MMTk object model
  #   GC header                              (determined by MMTk)
  #   Object id (age in allocations);        (WORD)
  #   Allocation site                        (WORD)
  #   The size of the data section in words. (WORD)
  #   The number of reference words.         (WORD)
  #   Status word (includes GC)              (WORD)
  #   References                             (....)
  #   Data                                   (....)
  class ObjectModel < org.mmtk.vm.ObjectModel
    import org.mmtk.plan.Plan

    MAX_DATA_FIELDS = java.lang.Integer::MAX_VALUE
    MAX_REF_FIELDS = java.lang.Integer::MAX_VALUE

    HEADER_WORDS = 5 + ActivePlan.constraints.gcHeaderWords
    HEADER_SIZE = HEADER_WORDS << Memory::LOG_BYTES_IN_WORD
    GC_HEADER_BYTES =
      ActivePlan.constraints.gcHeaderWords << Memory::LOG_BYTES_IN_WORD
    GC_OFFSET = Offset.zero
    ID_OFFSET = GC_OFFSET.plus(GC_HEADER_BYTES)
    SITE_OFFSET = ID_OFFSET.plus(Memory::BYTES_IN_WORD)
    DATACOUNT_OFFSET = SITE_OFFSET.plus(Memory::BYTES_IN_WORD)
    REFCOUNT_OFFSET = DATACOUNT_OFFSET.plus(Memory::BYTES_IN_WORD)
    STATUS_OFFSET = REFCOUNT_OFFSET.plus(Memory::BYTES_IN_WORD)
    REFS_OFFSET =STATUS_OFFSET.plus(Memory::BYTES_IN_WORD)

    @@object_id = 0
    @@lock = java.lang.Object.new

    class << self
      def last_object_id
        @@object_id
      end

      def allocateObject(context, ref_count, data_count, site)
        bytes = (HEADER_WORDS + ref_count + data_count) << Memory::LOG_BYTES_IN_WORD
        align = Memory::BYTES_IN_WORD
        ref_type = (ref_count == 0) ? Plan::ALLOC_NON_REFERENCE : Plan::ALLOC_DEFAULT
        allocator = context.check_allocator(bytes, align, ref_type)
        region = context.alloc(bytes, align, 0, allocator, 0)
        ref = region.to_object_reference
        set_id(ref, allocate_object_id)
        set_site(ref, site)
        set_ref_count(ref, ref_count)
        set_data_count(ref, data_count)

        # Call MMTk postAlloc
        context.post_alloc(ref, nil, bytes, allocator)

        return ref
      end

      def id(object)
        return (object.to_address.load_int(ID_OFFSET) >> 2)
      end

      def has_valid_id(object)
        return id(object) > 0 && id(object) < @@object_id
      end

      def site(object)
        return object.to_address.load_int(SITE_OFFSET)
      end

      def data_count(object)
        return object.to_address.load_int(DATACOUNT_OFFSET)
      end

      def ref_count(object)
        return object.to_address.load_int(REFCOUNT_OFFSET)
      end

      def size(object)
        words = HEADER_WORDS + ref_count(object) + data_count(object)
        return words << Memory::LOG_BYTES_IN_WORD
      end

      def hash_code(ref)
        return id(ref)
      end

      def ref_slot(object, index)
        return object.to_address.plus(REFS_OFFSET).
          plus(index << Memory::LOG_BYTES_IN_WORD)
      end

      def data_slot(object, index)
        return ref_slot(object, index + ref_count(object))
      end

      def dumpObject(object)
        $stderr.puts "==================================="
        $stderr.puts string(object).to_s
        $stderr.puts "==================================="
      end

      def string(ref)
        return "#{ref_and_space_string(ref)}#{object_id_string(ref)}" +
          "#{ref_count(ref)}R#{data_count(ref)}D"
      end

      def ref_and_space_string(ref)
        return "#{ref}/#{Space.space_for_object(ref).name}"
      end

      def address_and_space_string(addr)
        return "#{addr}/#{Space.space_for_address(addr).name}"
      end

      private
      def allocate_object_id
        return @@lock.synchronized do
          @@object_id += 1
        end
      end

      def set_id(object, value)
        object.to_address.store(value << 2, ID_OFFSET)
      end

      def set_site(object, site)
        object.to_address.store(site, SITE_OFFSET);
      end

      def set_data_count(object, count)
        object.to_address.store(count, DATACOUNT_OFFSET)
      end

      def set_ref_count(object, count)
        object.to_address.store(count, REFCOUNT_OFFSET)
      end

      def object_id_string(ref)
        return "[#{id(ref)}@#{Mutator.site_name(ref)}]"
      end
    end

    def copy(from, allocator)
      bytes = size(from)
      c = Scheduler.instance.current_collector();
      align = align_when_copied(from)
      allocator = c.copy_check_allocator(from, bytes, align, allocator)
      to_region = c.alloc_copy(from, bytes, align, align, allocator)
      to = to_region.to_object_reference
      from_region = from.to_address
      0.step(bytes, Memory::BYTES_IN_INT) do |i|
        to_region.plus(i).store(from_region.plus(i).load_int)
      end
      c.postCopy(to, nil, bytes, allocator)
      return to
    end

    def copyTo(from, to, to_region)
      do_copy = (from == to)
      bytes = size(from)

      if do_copy
        src = from.to_address
        dst = to.to_address
        0.step(bytes, Memory::BYTES_IN_INT) do |i|
          to_region.plus(i).store(from_region.plus(i).load_int)
        end
        Allocator.fill_alignment_gap(to_region, dst)
      end
      return object_end_address(to)
    end

    def getReferenceWhenCopiedTo(from, to)
      return to.to_object_reference
    end

    def getSizeWhenCopied(object)
      return size(object)
    end

    def getAlighWhenCopied(object)
      return 2 * Memory::BYTES_IN_WORD
    end

    def getAlignOffsetWhenCopied(object)
      return 0;
    end

    def getCurrentSize(object)
      return size(object)
    end

    ALIGNMENT_VALUE = 1

    def getNextObject(object)
      next_addr = object.to_address.plus(size(object))
      if next_addr.load_int == ALIGNMENT_VALUE
        next_addr = next_addr.plus(Memory::BYTES_IN_WORD)
      end
      if next_addr.load_word.zero?
        return ObjectReference.null_reference
      end
      return next_addr.to_object_reference
    end

    def getObjectFromStartAddress(start)
      if (start.load_int & ALIGNMENT_VALUE) != 0
        start = start.plus(Memory::BYTES_IN_WORD)
      end
      return start.to_object_reference
    end

    def getStartAddressFromObject(object)
      return object.to_address
    end

    def getObjectEndAddress(object)
      return object.to_address.plus(size(object))
    end

    def getTypeDescriptor(ref)
      return string(ref).bytes
    end

    def isArray(object)
      Assert.not_implemented
      return false
    end

    def isPrimitiveArray(object)
      Assert.not_implemented
      return false
    end

    def getArrayLength(object)
      Assert.not_implemented
      return 0
    end

    def attemptAvailableBits(object, old_val, new_val)
      return object.to_address.attempt(old_val, new_val, STATUS_OFFSET)
    end

    def prepareAvailableBits(object)
      return object.to_address.prepare_word(STATUS_OFFSET)
    end

    def writeAvailableByte(object, val)
      object.to_address.store(val, STATUS_OFFSET)
    end

    def readAvailableByte(object)
      return object.to_address.load_byte(STATUS_OFFSET)
    end

    def writeAvailableBitsWord(object, val)
      object.to_address.store(val, STATUS_OFFSET)
    end

    def readAvailableBitsWord(object)
      return object.to_address.load_word(STATUS_OFFSET)
    end

    def GC_HEADER_OFFSET
      return GC_OFFSET
    end

    def objectStartRef(object)
      return object.to_address
    end

    def refToAddress(object)
      return object.to_address
    end

    def isAcyclic(type_ref)
      return false
    end

    def getArrayBaseOffset
      return REFS_OFFSET
    end
  end
end
