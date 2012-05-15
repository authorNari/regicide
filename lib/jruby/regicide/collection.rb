require "regicide/scheduler"

module Regicide
  class Collection < org.mmtk.vm.Collection
    def prepareMutator(m)
      # Nothing to do
    end

    def requestMutatorFlush
      Assert.not_implemented
    end

    def blockForGC
      Scheduler.instance.wait_for_gc
    end

    def getDefaultThreads
      return 1
    end

    def getActiveThreads
      return Scheduler.instance.mutators.size
    end

    def outOfMemory
      raise java.lang.OutOfMemory
    end

    def spawnCollectorContext(context)
      Scheduler.instance.schedule_collector(context)
    end

    def stopAllMutators
      Scheduler.instance.stop_all_mutators
    end

    def resumeAllMutators
      Scheduler.instance.resume_all_mutators
    end
  end
end
