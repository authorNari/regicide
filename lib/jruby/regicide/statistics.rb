module Regicide
  class Statistics < org.mmtk.vm.Statistics
    # Read cycle counter
    def nanoTime
      return java.lang.System.nano_time
    end

    # Convert nanoseconds to milliseconds
    def nanoToMillis(c)
      return (c / 1e6)
    end

    # Convert nanoseconds to seconds
    def nanosToMillis(c)
      return (c) / 1e6
    end

    # Convert nanoseconds to seconds
    def nanosToSecs(c)
      return (c) / 1e9
    end

   # Convert milliseconds to nanoseconds
    def millisToNanos(t)
      return (t * 1e6)
    end

   # Convert seconds to nanoseconds
    def secsToNanos(t)
      return (t * 1e9)
    end

    # Read the cycle counter
    def cycles()
      return java.lang.System.nano_time
    end

   # Read (a set of) performance counters
    def perfEventRead(x, y)
      raise java.lang.UnsupportedOperationException.new(
        "Statistics#perfEventRead(): Not Implemented")
    end

   # Initialize performance counters
    def perfEventInit(events)
        return if events == ""
        raise java.lang.UnsupportedOperationException.new(
          "Statistics#perfEventInit("+events+"): Not Implemented")
    end
  end
end
