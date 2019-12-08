class Instruction
  def initialize(i)
    @i = i
  end

  def opcode
    @i % 100
  end

  def param_mode(n)
    @i / 10**(n+1) % 10
  end
end

class Computer
  attr_accessor :inputs, :out_amp, :output

  def initialize(program_file, out_amp=nil)
    @program_file = program_file
    @out_amp = out_amp
    @inputs = []
    reset
  end

  def reset
    @arr = File.open(@program_file).readlines[0].strip.split(',').map(&:to_i)
    @pos = 0
  end

  def param(index)
    @instruction.param_mode(index).zero? ? @arr[@arr[@pos+index]] : @arr[@pos+index]
  end

  def compute(*inputs)
    @inputs += inputs
    while @arr[@pos] != 99 do
      i = Instruction.new(@arr[@pos])
      @instruction = i
      case i.opcode
      when 1 # add
        @arr[@arr[@pos+3]] = param(1) + param(2)
        @pos += 4
      when 2 # multiply
        @arr[@arr[@pos+3]] = param(1) * param(2)
        @pos += 4
      when 3 # input
        @arr[@arr[@pos+1]] = @inputs.shift
        @pos += 2
      when 4 # output 
        @output = param(1)
        @pos += 2
        return @out_amp.compute(output) if @out_amp
      when 5 # jump if true
        if !param(1).zero?
          @pos = param(2)
        else
          @pos += 3
        end
      when 6 # jump if false
        if param(1).zero?
          @pos = param(2)
        else
          @pos += 3
        end
      when 7
        @arr[@arr[@pos+3]] = (param(1) < param(2)) ? 1 : 0
        @pos += 4
      when 8
        @arr[@arr[@pos+3]] = (param(1) == param(2)) ? 1 : 0
        @pos += 4
      end
    end
    return @output
  end
end

totals = [5,6,7,8,9].permutation.map do |perm|
  ampE = Computer.new('input')
  ampD = Computer.new('input', ampE)
  ampC = Computer.new('input', ampD)
  ampB = Computer.new('input', ampC)
  ampA = Computer.new('input', ampB)
  ampE.out_amp = ampA

  ampA.inputs.push(perm[0], 0)
  ampB.inputs.push(perm[1])
  ampC.inputs.push(perm[2])
  ampD.inputs.push(perm[3])
  ampE.inputs.push(perm[4])
  ampA.compute
  ampE.output
end

puts totals.max.inspect
