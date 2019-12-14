class Equation
  attr_accessor :inputs, :output
end

class Chemical
  attr_accessor :name, :qty, :ingredients

  def self.from_string(str)
    new(*str.strip.split(' '))
  end

  def initialize(qty, name)
    @qty, @name = qty.to_i, name
  end
end


@equations = File.readlines('input').map do |line|
  inputs = line.split('=>').first.strip
  output = line.split('=>').last.strip
  equation = Equation.new
  equation.inputs = inputs.split(',').map { |s| Chemical.from_string(s) }
  equation.output = Chemical.from_string(output)
  equation
end


@hsh = Hash.new(0)
@hsh['FUEL'] = 1

def fuel_complete
  @hsh.map{ |(k,v)| k if v > 0 }.compact == ['ORE']
end

until fuel_complete do
  @hsh.dup.each do |(k,v)|
    next if v <= 0
    next if k == 'ORE'

    equation = @equations.detect { |e| e.output.name == k }
    @hsh[k] -= equation.output.qty
    equation.inputs.each { |i| @hsh[i.name] += i.qty }
  end
end

puts @hsh['ORE']
