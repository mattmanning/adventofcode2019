class Moon
  attr_reader :position, :history
  attr_accessor :repeated

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

done = Hash.new
[0,1,2].each do |m|
  [0,1,2].each do |pos|
    done[[m,pos]] = nil
  end
end

history = Hash.new([])

n = 0

while done.values.any?(&:nil?)
  [0,1,2].each do |m|
    [0,1,2].each do |pos|
      next if done[[m,pos]]
      history[[m,pos]] = history[[m,pos]] + [moons[m].position[pos]]
    end
  end

  moons.combination(2).each do |combo|
    moon1 = combo.first
    moon2 = combo.last
    moon1.gravity(moon2)
    moon2.gravity(moon1)
  end

  moons.each do |moon|
    moon.move
  end

  keys = done.select { |k,v| v.nil? }.keys
  keys.each do |key|
    if history[key] == history[key].reverse
      if n > 0
        done[key] = n + 1
      end
    end
  end
  n += 1
end

puts done.values.uniq.inject(1) { |multiple, v| multiple.lcm(v) } 