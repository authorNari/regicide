require "singleton"

module Regicide
  class OptionSet < org.vmutil.options.OptionSet
    import org.vmutil.options.Option
    include Singleton

    def process(arg)
      if arg == "help" || arg == "dump"
        help
        return true
      end

      s = arg.split("=")
      if s.size != 2
        $stderr.puts "Illegal options: #{arg}"
        return false
      end

      o = getOption(s[0])
      v = s[1]
      return false if o.nil?

      case o.type
      when Option::BOOLEAN_OPTION
        if v == "true"
          o.value = true
          return true
        elsif v == "false"
          o.value = false 
          return true
        end
        return false
      when Option::INT_OPTION
        o.value = v.to_i
      when Option::ADDRESS_OPTION
        o.value = v.to_i(16)
      when Option::FLOAT_OPTION
        o.value = v.to_f
      when Option::STRING_OPTION
        o.value = v
      when Option::ENUM_OPTION
        o.value = v
      when Option::PAGES_OPTION
        factor = 1
        case v.to_s[-1]
        when /(g|G)/
          factor = factor * 1024 * 1024 * 1024
        when /(m|M)/
          factor = factor * 1024 * 1024
        when /(k|K)/
          factor = factor * 1024
        end
        o.bytes = Extent.from_int_zero_extend(v.to_i * factor)
      when Option::MICROSECONDS_OPTION
        o.microseconds = v.to_i
      else
        return false
      end

      return true
    end

    def help
      $stderr.puts "regicide <entry point> <script file> [options]"
      $stderr.puts "Options:"
      o = getFirst
      while !o.nil?
        $stderr.print "\t#{o.key.to_s.ljust(31)} = "
        log_value(o, false)
        $stderr.print "\n"
        o = o.getNext
      end
    end

    def logValue(o, for_xml)
      case o.type
      when Option::MICROSECONDS_OPTION
        $stderr.print o.value.microseconds.to_s
      when Option::PAGES_OPTION
        $stderr.print o.bytes.to_s
      when Option::ENUM_OPTION
        $stderr.print o.value_string.to_s
      else
        $stderr.print o.value.to_s
      end
    end

    def logString(s)
      $stderr.print s.to_s
    end

    def logNewLine
      $stderr.puts ""
    end

    def computeKey(name)
      return name.to_s.downcase.gsub(' ', '')
    end

    def warn(o, msg)
      $stderr.puts "WARNING: Option '#{o.key}' : #{msg}"
    end

    def fail(o, msg)
      raise "Option '#{o.key}' : #{msg}"
    end

    def bytesToPages(bytes)
      return bytes.plus(Memory::BYTES_IN_PAGE-1).
        to_word.rshl(Memory::LOG_BYTES_IN_PAGE).to_int
    end

    def pagesToBytes(pages)
      return Word.from_int_zero_extend(pages).
        lsh(Memory::LOG_BYTES_IN_PAGE).to_extent
    end

    class InitHeap < org.vmutil.options.PagesOption
      def initialize
        super(Regicide::OptionSet.instance, "Init Heap", "Initial Heap Size", 384)
      end

      def validate
        fail_if(value == 0, "Must have a non-zero heap size")
      end
    end

    class MaxHeap < org.vmutil.options.PagesOption
      def initialize
        super(Regicide::OptionSet.instance, "Max Heap", "Max Heap Size", 384)
      end

      def validate
        fail_if(value == 0, "Must have a non-zero heap size")
      end
    end
  end
end
