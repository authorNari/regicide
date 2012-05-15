module Regicide
  class Scheduler
    class Lock < org.mmtk.vm.Lock
      def initialize(name)
        super()
        @mutex = Mutex.new
        setName(name)
      end

      def setName(name)
        @name = name.to_s
      end

      def acquire
        @mutex.lock
        @holder = Thread.current
      end

      def check(w)
        $stderr.puts("[#{@name}] AT #{w} held by #{@holder}")
      end

      def release
        @mutex.unlock
      end
    end
  end
end
