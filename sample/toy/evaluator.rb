module Toy
  class Evaluator
    def initialize(mutator)
      @mutator = mutator
      @mutator.stack_push(Regicide::Mutator::StackFrame.new)
    end

    def evaluate(sequence)
      @mutator.current_stack.code = sequence
      while insn = @mutator.current_stack.code[@mutator.current_stack.pc]
        dispatch insn
      end
      to_ruby(@mutator.current_stack[0])
    end

    def dispatch(insn)
      case insn.code
      when :nop

      when :push
        push insn.opts[0]

      when :pop
        pop

      when :dup
        popped = pop
        push popped
        push popped

      when :add
        push pop + pop

      when :sub
        push pop - pop

      when :mul
        push pop * pop

      when :div
        push pop / pop

      when :not
        push !pop

      when :smaller
        push pop < pop

      when :bigger
        push pop > pop

      when :goto
        @mutator.current_stack.pc = insn.opts[0].pos
        return

      when :if
        if pop
          @mutator.current_stack.pc = insn.opts[0].pos
          return
        end

      else
        raise "Unknown Opcode: #{insn}"

      end

      @mutator.current_stack.pc += 1
    end

    def push(obj)
      @mutator.current_stack.push(to_mmtk(obj))
    end

    def pop
      return to_ruby(@mutator.current_stack.pop)
    end

    def to_mmtk(obj)
      # supported fixnum only.
      case obj
      when Fixnum
        v = FixnumValue.from_i(@mutator, obj)
      when TrueClass, FalseClass
        v = BoolValue.new(obj)
      else
        raise "Unsupported value : #{obj}"
      end
    end

    def to_ruby(obj)
      case obj
      when FixnumValue
        v = obj.to_i(@mutator)
      when BoolValue
        v = obj.object_value
      when NilClass
        v = nil
      else
        raise "Unsupported value : #{obj}"
      end
    end
  end
end
