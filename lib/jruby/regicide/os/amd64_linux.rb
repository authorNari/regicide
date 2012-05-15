# -*- coding: utf-8 -*-
require "ffi"

module Regicide
  module OS
    module Amd64Linux
      class LibC
        extend FFI::Library
        ffi_lib FFI::Library::LIBC
        attach_function :malloc, [:size_t], :pointer
        attach_function :free, [:pointer], :void
        attach_function(:mmap,
          [:pointer, :size_t, :int, :int, :int, :off_t], :pointer)
        attach_function :munmap, [:pointer, :size_t], :pointer
        attach_function :mprotect, [:pointer, :size_t, :int], :int
        attach_function :memset, [:pointer, :int, :size_t], :void

        PROT_NONE = 0
        PROT_READ = 1
        PROT_WRITE = 2
        PROT_EXEC = 4
        MAP_PRIVATE = 2
        MAP_FIXED = 16
        MAP_ANONYMOUS = 32
      end

      LOG_BYTES_IN_PAGE = 12
      LOG_BYTES_IN_WORD = 3
      LOG_BYTES_IN_ADDRESS = 3

      def self.dzmmap(addr, size)
        prot = LibC::PROT_READ | LibC::PROT_WRITE | LibC::PROT_EXEC
        flags = LibC::MAP_ANONYMOUS | LibC::MAP_PRIVATE | LibC::MAP_FIXED
        res =
          LibC.mmap(FFI::Pointer.new(addr.to_long),
            size, prot, flags, -1, 0).to_i
        return 0 if res == addr.to_long
        return Sys.get_errno
      end

      def self.mprotect(start, size)
        return LibC.mprotect(FFI::Pointer.new(start.to_long),
          size, LibC::PROT_NONE)
      end

      def self.munprotect(start, size)
        return LibC.mprotect(FFI::Pointer.new(start.to_long),
          size, LibC::PROT_READ | LibC::PROT_WRITE | LibC::PROT_EXEC)
      end

      def self.zero(dst, cnt)
        LibC.memset(FFI::Pointer.new(dst.to_long), 0x00, cnt.to_long)
      end
    end
  end
end
