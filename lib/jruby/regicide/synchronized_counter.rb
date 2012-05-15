module Regicide

  # A counter that supports atomic increment and reset.
  class SynchronizedCounter < org.mmtk.vm.SynchronizedCounter
    def initialize
      @value = 0
    end

    # Reset the counter to 0, returning its previous value.
    def reset
      synchronized do
        old = @value
        @value = 0
        return old
      end
    end

    def increment
      synchronized{ @value += 1}
    end

    def peek
      return @value
    end
  end
end
