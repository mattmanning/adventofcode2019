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
  def initialize(program_file)
    @program_file = program_file
  end

  def reset
    @arr = File.open(@program_file).readlines[0].strip.split(',').map(&:to_i)
    @pos = 0
  end

  def param(index)
    @instruction.param_mode(index).zero? ? @arr[@arr[@pos+index]] : @arr[@pos+index]
  end

  def compute(*inputs)
    @inputs = inputs
    reset
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
        output = param(1)
        @pos += 2
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
    return output
  end
end

computer = Computer.new('input')

totals = [0,1,2,3,4].permutation.map do |perm|
  perm.inject(0) do |input,phase_setting|
    computer.compute(phase_setting, input)
  end
end

puts totals.max
