
module Regicide
  class Scanning < org.mmtk.vm.Scanning
    def scanObject(trace, obj)
      refs = ObjectModel.ref_count(obj)
      first = obj.to_address.plus(ObjectModel::REFS_OFFSET)
      refs.times do |i|
        trace.process_edge(
          obj, first.plus(i << Memory::LOG_BYTES_IN_ADDRESS))
      end
    end

    def specializedScanObject(id, trace, obj)
      scan_object(trace, obj)
    end

    def resetThreadCounter
      @mutators_to_scan = nil
      Mutator::ObjectValue.start_root_discovery_phase
    end

    def notifyInitialThreadScanComplete
      # do nothing
    end

    def computeStaticRoots(trace)
      # do nothing
    end

    def computeGlobalRoots(trace)
      # do nothing
    end

    def computeThreadRoots(trace)
      self.synchronized do
        if @mutators_to_scan.nil?
          @mutators_to_scan = Mutator.mutators
        end
      end
      @mutators_to_scan.values.each do |m|
        m.compute_thread_roots(trace)
      end
    end

    def computeBootImageRoots(trace)
      # do nothing
    end
  end
end
