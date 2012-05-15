require "ffi"

module Regicide
  module OS
    class Sys
      extend FFI::Library
      ffi_lib "ext/regicide/libsys.so"
      attach_function :int2ulong, [:int], :ulong
      attach_function :long2ulong, [:long], :ulong
      attach_function :get_errno, [], :int
    end

    class ArchitecturalWord
      include Comparable

      def initialize(value=0)
        @v = FFI::Pointer.new(value)
      end

      attr_reader :v

      def self.from_long(v)
        self.new(v)
      end

      def self.from_int_zero_extend(v)
        from_long(Sys.int2ulong(v))
      end

      def to_long_zero_extend
        Sys.long2ulong(@v.to_i)
      end

      def max?
        self.v >= self.class.max.v
      end

      def self.max
        new(-1)
      end

      def <=>(other)
        if other.is_a?(self.class)
          res = @v.to_i - other.v.to_i
          case
          when res > 0
            return 1
          when res < 0
            return -1
          else
            return 0
          end
        else
          nil
        end
      end

      define_method("!=") do |other|
        !(self == other)
      end

      def self.zero
        new(0)
      end

      def zero?
        @v.to_i == 0
      end

      def to_i
        @v.to_i
      end

      def plus(offset)
        self.class.from_long(@v.to_i + offset)
      end

      def minus(offset)
        self.class.from_long(@v.to_i - offset)
      end

      def and(w)
        self.class.from_long(@v.to_i & w.v.to_i)
      end

      def lsh(amt)
        self.class.from_long(@v.to_i << amt)
      end

      def not
        self.class.from_long(~@v.to_i)
      end

      def or(w)
        self.class.from_long(@v.to_i | w.v.to_i)
      end

      def xor(w)
        self.class.from_long(@v.to_i ^ w.v.to_i)
      end

      def rsha(amt)
        self.class.from_long(@v.to_i >> amt)
      end

      def diff(w)
        self.class.from_long(@v.to_i - w.v.to_i)
      end

      def write_char(val)
        @v.write_char(val)
      end

      def write_word(val)
        @v.write_pointer(val.v)
      end

      def write_byte(val)
        @v.write_char(val)
      end

      def write_int(val)
        @v.write_int(val)
      end

      def write_double(val)
        @v.write_double(val)
      end

      def write_long(val)
        @v.write_long(val)
      end

      def write_float(val)
        @v.write_float(val)
      end

      def write_short(val)
        @v.write_short(val)
      end

      def read_char
        @v.read_char
      end

      def read_word
        self.class.new(@v.read_pointer.address)
      end

      def read_byte
        @v.read_char
      end

      def read_int
        @v.read_int
      end

      def read_double
        @v.read_double
      end

      def read_long
        @v.read_long
      end

      def read_float
        @v.read_float
      end

      def read_short
        @v.read_short
      end

      def to_s
        @v.to_s
      end
    end
  end
end
