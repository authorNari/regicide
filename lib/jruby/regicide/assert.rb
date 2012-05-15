module Regicide
  class Assert < org.mmtk.vm.Assert
    def self.notImplemented
      raise java.lang.UnsupportedOperationException.new("Not Implemented")
    end

    def fail(message)
      raise "Assertion Failed: #{message}"
    end

    def _assert(cond, msg="")
      fail(msg) if !cond
    end

    def dumpStack
      puts Exception.new.backtrace
    end

    def runningVM
      return true
    end

    def getVerifyAssertionsConstant
      str = java.lang.System.get_property(
              "org.mmtk.harness.verify.assertions", "true")
      return java.lang.Boolean.value_of(str)
    end
  end
end
