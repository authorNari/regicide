# -*- coding: utf-8 -*-
module Regicide
  class Memory < org.mmtk.vm.Memory
    LOG_BYTES_IN_ADDRESS = Regicide.os::LOG_BYTES_IN_ADDRESS
    LOG_BYTES_IN_PAGE = Regicide.os::LOG_BYTES_IN_PAGE
    LOG_BYTES_IN_LONG = 3
    LOG_BYTES_IN_WORD = Regicide.os::LOG_BYTES_IN_WORD
    LOG_BYTES_IN_INT = 2
    LOG_BYTES_IN_SHORT = 1
    LOG_BITS_IN_BYTE = 3
    BYTES_IN_PAGE = 1 << LOG_BYTES_IN_PAGE
    BYTES_IN_LONG = 1 << LOG_BYTES_IN_LONG
    BYTES_IN_WORD = 1 << LOG_BYTES_IN_WORD
    BYTES_IN_INT = 1 << LOG_BYTES_IN_INT
    BYTES_IN_SHORT = 1 << LOG_BYTES_IN_SHORT
    BITS_IN_BYTE = 1 << LOG_BITS_IN_BYTE
    BYTES_IN_ADDRESS = 1 << LOG_BYTES_IN_ADDRESS
    INT_MASK = ~(BYTES_IN_INT - 1)
    WORD_MASK = ~(BYTES_IN_WORD - 1)
    PAGE_MASK = ~(BYTES_IN_PAGE - 1)
    LOG_BYTES_IN_MBYTE = 20

    VMSPACE_SIZE = Extent.fromIntZeroExtend(0x10000000)
    HEAP_START = Address.fromIntZeroExtend(0x10000000)
    HEAP_END = Address.fromLong(0xA0000000)

    @@vm_space = nil

    def getVMSpace()
      if @@vm_space.nil?
        req = org.mmtk.utility.heap.VMRequest.create(VMSPACE_SIZE, false)
        @@vm_space = org.mmtk.policy.ImmortalSpace.new("vm", req)
      end
      return @@vm_space
    rescue
      $stderr.puts $!
      $stderr.puts $!.backtrace
      raise $!
    end

    def globalPrepareVMSpace
      # Nothing in vm space
    end

    def collectorPrepareVMSpace
      # Nothing in vm space
    end

    def collectorReleaseVMSpace
      # Nothing in vm space
    end

    def globalReleaseVMSpace
      # Nothing in vm space
    end

    def setHeapRange(id, addr_start, addr_end)
      # TODO: More checking possible
    end

    def dzmmap(start, size)
      return Regicide.os.dzmmap(start, size)
    end

    def mprotect(start, size)
      return Regicide.os.mprotect(start, size)
    end

    def munprotect(start, size)
      return Regicide.os.munprotect(start, size)
    end

    def zero(useNT, start, len)
      Regicide.os.zero(start, len)
    end

    def dumpMemory(start, before_bytes, after_bytes)
      before_bytes = align_down(before_bytes, BYTES_IN_ADDRESS)
      after_bytes = align_up(after_bytes, BYTES_IN_ADDRESS)
      from = start.minus(before_bytes).to_long
      to = start.plus(after_bytes).to_long
      puts "---- Dumping memory from #{from.to_s(16)} to #{to.to_s(16)} ----"
      from.step(to, BYTES_IN_ADDRESS) do |i|
        puts "#{i}: #{Address.from_long(i).load_word}"
      end
    end

    def sync
      Scheduler.instance.yield
    end

    def isync
      Scheduler.instance.yield
    end

    def getHeapStartConstant
      HEAP_START
    end

    def getHeapEndConstant
      HEAP_END
    end

    def getAvailableStartConstant
      HEAP_START.plus(VMSPACE_SIZE)
    end

    def getAvailableEndConstant
      HEAP_END
    end

    def getLogBytesInAddressConstant
      LOG_BYTES_IN_ADDRESS
    end

    def getLogBytesInWordConstant 
      LOG_BYTES_IN_WORD
    end

    def getLogBytesInPageConstant
      LOG_BYTES_IN_PAGE
    end

    def getLogMinAlignmentConstant
      LOG_BYTES_IN_WORD
    end

    def getMaxAlignmentShiftConstant
      1
    end

    def getMaxBytesPaddingConstant
      BYTES_IN_WORD
    end

    def getAlignmentValueConstant
      ObjectModel::ALIGNMENT_VALUE
    end

    private
    def align_down(addr, alignment)
      return (addr & ~(alignment - 1))
    end

    def align_up(addr, alignment)
      return ((addr + alignment - 1) & ~(alignment - 1))
    end
  end
end
