module Regicide
  class VM
    import org.mmtk.utility.options.Options

    @@plan = nil
    @@plan_on_ruby = nil
    @@init_heap = Regicide::OptionSet::InitHeap.new
    @@max_heap = Regicide::OptionSet::MaxHeap.new

    def run(*args)
      if @@plan.nil? && @@plan_on_ruby.nil?
        raise "You must specify @@plan or @@plan_on_ruby on your VM"
      end
      @@plan_on_ruby.nil? ? setup_plan : setup_plan_on_ruby
      ActivePlan.plan.enable_allocation;
      options = Regicide::OptionSet.instance
      args.each do |arg|
        options.process(arg)
      end
      org.mmtk.utility.heap.HeapGrowthManager.boot(
        @@init_heap.get_bytes, @@max_heap.get_bytes)

      # default options
      Options.noFinalizer.setValue(true);
      Options.variableSizeHeap.setValue(false);

      # Finish starting up MMTk
      ActivePlan.plan.processOptions();
      ActivePlan.plan.enableCollection();
      ActivePlan.plan.fullyBooted();
    end

    def self.define_plan(plan)
      @@plan = plan
    end

    def self.define_plan_on_ruby(prefix, prefix_path, constraints_path)
      if prefix_path == constraints_path
        raise "please define the other .rb file for constraints"
      end
      @@plan_on_ruby =
        {:prefix => prefix, :prefix_path => prefix_path,
        :constraints_path => constraints_path}
    end

    def setup_plan
      java.lang.System.set_property("mmtk.regicide.plan", @@plan)
      ActivePlan.setup_constraints(@@plan)
      ActivePlan.setup_plan(@@plan)
    end

    def setup_plan_on_ruby
      @@plan = @@plan_on_ruby[:prefix]
      java.lang.System.set_property("mmtk.regicide.plan", @@plan)
      java.lang.System.set_property("mmtk.regicide.plan.ruby", @@plan)
      require @@plan_on_ruby[:constraints_path]
      ActivePlan.setup_constraints(@@plan)
      require @@plan_on_ruby[:prefix_path]
      ActivePlan.setup_plan(@@plan)
    end
  end
end
