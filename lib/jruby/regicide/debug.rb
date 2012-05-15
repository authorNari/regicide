module Regicide
  class Debug < org.mmtk.vm.Debug
    def isEnabled
      return true
    end

    def format(obj)
      if obj.null?
        return obj.to_string
      end
      return ObjectModel.string(obj)
    end

    def format(addr)
      return ObjectModel.address_and_space_string(addr)
    end

    def arrayRemsetEntry(start, guard)
      puts "arrayRemset: [#{start},${guard})" if $DEBUG
    end

    def modbufEntry(obj)
      puts "modbuf: #{format(obj)}" if $DEBUG
    end

    def remsetEntry(slot)
      if $DEBUG
        puts "remset: #{format(slot)}->" +
          "#{format(slot.load_object_reference)}"
      end
    end

    def globalPhase(phase_id, before)
      # none
    end

    def traceObject(trace, obj)
      puts "traceObject: #{format(obj)}" if $DEBUG
    end

    def queueHeadInsert(queue_name, value)
      puts "head insert #{value} to #{queue_name}" if $DEBUG
    end

    def queueHeadRemove(queue_name, value)
      puts "head remove #{value} to #{queue_name}" if $DEBUG
    end

    def queueTailInsert(queue_name, value)
      puts "tail insert #{value} to #{queue_name}" if $DEBUG
    end

    def queueTailRemove(queue_name, value)
      puts "tail remove #{value} to #{queue_name}" if $DEBUG
    end
  end
end
