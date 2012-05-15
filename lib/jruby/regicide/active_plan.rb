module Regicide
  class ActivePlan < org.mmtk.vm.ActivePlan
    def self.setup_constraints(prefix)
      @@constraints = eval("#{prefix}Constraints.new")
    end

    def self.setup_plan(prefix)
      @@plan = eval("#{prefix}.new")
    end

    def self.constraints
      @@constraints
    end

    def self.plan
      @@plan
    end

    def global
      @@plan
    end

    def constraints
      @@constraints
    end

    def collector
      Scheduler.instance.current_collector
    end

    def log
      Scheduler.current_log
    end

    def mutator
      Scheduler.instance.current_mutator.context
    end

    def resetMutatorIterator
      @@mutators = nil
    end

    def getNextMutator
      self.synchronized do
        @@mutators ||= Mutator.mutators.values
      end
      m = @@mutators.pop
      return m.nil? ? nil : m.context
    end

    def isMutator
      return Scheduler.instance.mutator?
    end
  end
end
