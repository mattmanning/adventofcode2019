str = File.open('input').readlines[0].strip
arr = str.split(',').map(&:to_i)

pos = 0
input = 1

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

while arr[pos] != 99 do
  i = Instruction.new(arr[pos])
  case i.opcode
  when 1 # add
    a = i.param_mode(1).zero? ? arr[arr[pos+1]] : arr[pos+1]
    b = i.param_mode(2).zero? ? arr[arr[pos+2]] : arr[pos+2]
    arr[arr[pos+3]] = a + b
    pos += 4
  when 2 # multiply
    a = i.param_mode(1).zero? ? arr[arr[pos+1]] : arr[pos+1]
    b = i.param_mode(2).zero? ? arr[arr[pos+2]] : arr[pos+2]
    arr[arr[pos+3]] = a * b
    pos += 4
  when 3 # input
    arr[arr[pos+1]] = input
    pos += 2
  when 4 # output 
    output = i.param_mode(1).zero? ? arr[arr[pos+1]] : arr[pos+1]
    puts output
    pos += 2
  end
end
