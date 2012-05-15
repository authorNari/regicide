module Toy
  class Parser
    def self.parse(program)
      pc     = 0
      labels = {}
      program.map{|line|
        line = line.strip
        insn = []

        if /\A:\w+\z/ =~ line
          label = $~[0].intern
          unless lobj = labels[label]
            lobj  = ::Toy::VM::Label.new label
            labels[label] = lobj
          end
          next lobj
        end

        while line.size > 0
          case line
          when /\A:[a-z]+/
            # label
            label = $~[0].intern
            unless lobj = labels[label]
              lobj = ::Toy::VM::Label.new label
              labels[label] = lobj
            end
            insn << lobj

          when /\A\s+/, /\A\#.*/
            # ignore

          when /\A[a-z]+/
            insn << $~[0].intern

          when /\A\d+/
            insn << $~[0].to_i

          else
            raise "Parse Error: #{line}"

          end
          line = $~.post_match
        end

        insn.size > 0 ? insn : nil
      }.compact.map{|insn|
        if insn.kind_of? ::Toy::VM::Label
          insn.pos = pc
          nil
        else
          pc += 1
          ::Toy::VM::Instruction.new insn[0], insn[1..-1]
        end
      }.compact
    end
  end
end
