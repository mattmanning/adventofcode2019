class Instruction
  attr_accessor :i

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
    @hsh = Hash.new(0)
    File.open(@program_file).readlines[0].strip.split(',').map(&:to_i).each_with_index do |n, index|
      @hsh[index] = n
    end
    @pos = 0
    @base = 0
  end

  def param(index)
    case @instruction.param_mode(index)
    when 0 # position mode
      @hsh[@pos+index]
    when 1 # immediate mode
      @pos+index
    when 2 # relative mode
      @hsh[@pos+index]+@base
    end
  end

  def compute(*inputs)
    @inputs = inputs
    reset
    while @hsh[@pos] != 99 do
      @instruction = Instruction.new(@hsh[@pos])
      case @instruction.opcode
      when 1 # add
        @hsh[param(3)] = @hsh[param(1)] + @hsh[param(2)]
        @pos += 4
      when 2 # multiply
        @hsh[param(3)] = @hsh[param(1)] * @hsh[param(2)]
        @pos += 4
      when 3 # input
        @hsh[param(1)] = @inputs.shift
        @pos += 2
      when 4 # output 
        output = @hsh[param(1)]
        @pos += 2
        puts output
      when 5 # jump if true
        if !@hsh[param(1)].zero?
          @pos = @hsh[param(2)]
        else
          @pos += 3
        end
      when 6 # jump if false
        if @hsh[param(1)].zero?
          @pos = @hsh[param(2)]
        else
          @pos += 3
        end
      when 7
        @hsh[param(3)] = (@hsh[param(1)] < @hsh[param(2)]) ? 1 : 0
        @pos += 4
      when 8
        @hsh[param(3)] = (@hsh[param(1)] == @hsh[param(2)]) ? 1 : 0
        @pos += 4
      when 9 # adjust base
        @base += @hsh[param(1)]
        @pos += 2
      end
    end
  end
end

computer = Computer.new('input')
# Part 1
# computer.compute(1)
# Part 2
computer.compute(2)
