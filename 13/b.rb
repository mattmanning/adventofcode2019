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
    @hsh[0] = 2
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

  def compute(cabinet)
    @cabinet = cabinet
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
        @hsh[param(1)] = @cabinet.joystick
        @pos += 2
      when 4 # output 
        output = @hsh[param(1)]
        @pos += 2
        @cabinet.push_data(output)
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

class Cabinet
  attr_accessor :screen

  def initialize
    @data = []
    @screen = Hash.new
  end

  def push_data(data)
    @data << data
    draw if @data.length == 3
  end

  def joystick
    ballx <=> paddlex
  end

  private

  def ballx
    @screen.key(4).first
  end

  def paddlex
    @screen.key(3).first
  end

  def draw
    x = @data.shift
    y = @data.shift
    tile = @data.shift

    @screen[[x,y]] = tile
  end
end

computer = Computer.new('input')
cab = Cabinet.new
computer.compute(cab)
puts cab.screen[[-1,0]]
