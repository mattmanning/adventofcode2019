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

  def compute(robot)
    @robot = robot
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
        @hsh[param(1)] = @robot.get_color
        @pos += 2
      when 4 # output 
        output = @hsh[param(1)]
        @pos += 2
        @robot.push_data(output)
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

class Robot
  attr_reader :visited, :panel

  def initialize
    @data = []
    @position = [0,0]
    @panel = Hash.new(1)
    @visited = Hash.new
    @direction = [0, 1]
    @turns = {
      [0,1] => [-1, 0],
      [-1, 0] => [0, -1],
      [0, -1] => [1, 0],
      [1, -0] => [0, 1]
    }
  end

  def push_data(data)
    @data << data
    paint_and_move if @data.length == 2
  end

  def get_color
    @panel[@position]
  end

  def print_panel
    xmin = panel.keys.map(&:first).min
    xmax = panel.keys.map(&:first).max
    ymin = panel.keys.map(&:last).min
    ymax = panel.keys.map(&:last).max

    (ymax+1).downto(ymin-1) do |y|
      (xmin-1).upto(xmax+1) do |x|
        print @panel[[x,y]] == 0 ? ' ' : '*'
      end
      print "\n"
    end
  end

  private

  def paint_and_move
    @panel[@position] = @data.shift
    @visited[@position] = true
    case @data.shift
    when 0
      turn_left
    when 1
      turn_right
    end
    move
  end

  def turn_left
    @direction = @turns[@direction]
  end

  def turn_right
    @direction = @turns.key(@direction)
  end

  def move
    @position = @position.zip(@direction).map(&:sum)
  end
end

computer = Computer.new('input')
robot = Robot.new
computer.compute(robot)
robot.print_panel