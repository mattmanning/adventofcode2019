class Moon
  attr_reader :position

  def initialize(str)
    @position = str[1..-2].split(',').map {|pos| pos.split('=').last.to_i}
    @velocity = [0,0,0]
  end

  def gravity(moon)
    [0,1,2].each do |i|
      @velocity[i] += moon.position[i] <=> @position[i]
    end
  end

  def move
    [0,1,2].each do |i|
      @position[i] += @velocity[i]
    end
  end

  def energy
    pot = @position.inject(0) { |sum, pos| sum + pos.abs }
    kin = @velocity.inject(0) { |sum, vel| sum + vel.abs }
    pot * kin
  end
end

moons = File.open('input').map do |line|
  Moon.new(line)
end

1000.times do
  moons.combination(2).each do |combo|
    moon1 = combo.first
    moon2 = combo.last
    moon1.gravity(moon2)
    moon2.gravity(moon1)
  end

  moons.each do |moon|
    moon.move
  end
end

puts moons.map(&:energy).sum
