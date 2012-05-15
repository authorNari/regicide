module Regicide
  class MMTkEvents < org.mmtk.vm.MMTk_Events
    def heapSizeChanged(heap_size)
    end

    def tracePageAcquired(space, start_address, num_pages)
    end

    def tracePageReleased(space, start_address, num_pages)
    end
  end
end
