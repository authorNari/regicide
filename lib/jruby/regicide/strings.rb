module Regicide
  class Strings < org.mmtk.vm.Strings
    # Log a message.
    def write(c, len)
      x = java.lang.String.new(c, 0, len)
      $stderr.puts(x.to_s)
    end

    # Log a thread identifier and a message.
    def writeThreadId(c, len)
      x = java.lang.String.new(c, 0, len)
      $stderr.puts("#{Thread.current.object_id}:#{x}")
    end

    # Copies characters from the string into the character array.
    # Thread switching is disabled during this method's execution.
    def copyStringToChars(src, dst, dst_begin, dst_end)
      count = 0
      src.to_s.unpack("c*").each do |c|
        break if dst_begin > dst_end
        dst[dst_begin] = c
        dst_begin+=1
        count+=1
      end
      return count
    end
  end
end
