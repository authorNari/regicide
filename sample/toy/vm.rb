# Toy VM 
# inspired by RubiMaVM (http://jp.rubyist.net/magazine/?0007-YarvManiacs)

require "fixnum_value"
require "bool_value"
require "evaluator"
require "parser"

module Toy
  class VM < Regicide::VM
    # define_plan "org.mmtk.plan.marksweep.MS"
    define_plan_on_ruby "Toy::Plan::MS", "plan/ms.rb", "plan/ms_constraints.rb"

    class Instruction
      def initialize code, opts
        @code = code
        @opts = opts
      end
      attr_reader :code, :opts

      def inspect
        "#{code} <#{opts.join ', '}>"
      end
    end

    class Label
      @@id = 0
      def initialize label
        @label = label
        @pos = -1
        @id  = @@id+=1
      end
      attr_accessor :pos

      def inspect
        "#{@label} <#{@id}@#{@pos}>"
      end
      alias to_s inspect
    end

    def run(*args)
      raise "You must specify *.ty" if args[0].nil?
      src = File.read(args.shift)
      super
      require "plan/ms"
      Regicide::Scheduler.instance.schedule_mutator do |mutator|
        seq = Parser.parse(src)
        seq.each_with_index{|insn, i| puts "#{'%04d' % i}\t#{insn.inspect}" }
        p Evaluator.new(mutator).evaluate(seq)
      end
      Regicide::Scheduler.instance.schedule
    end
  end
end

Toy::VM.new
