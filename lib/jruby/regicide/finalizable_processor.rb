module Regicide
  class FinalizableProcessor < org.mmtk.vm.FinalizableProcessor
    def clear
    end

    def scan(trace, nursery)
      Assert.not_implemented "Not supported"
    end

    def forward(trace, nursery)
      Assert.not_implemented "Not supported"
    end
  end
end
