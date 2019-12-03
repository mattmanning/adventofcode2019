lines = File.open('input').readlines
wire1 = lines[0].strip.split(',')
wire2 = lines[1].strip.split(',')

# wire1 = 'R75,D30,R83,U83,L12,D49,R71,U7,L72'.strip.split(',')
# wire2 = 'U62,R66,U55,R34,D71,R55,D58,R83'.strip.split(',')

# wire1 = 'R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51'.strip.split(',')
# wire2 = 'U98,R91,D20,R16,D67,R40,U7,R15,U6,R7'.strip.split(',')

$grid = Hash.new
$steps_grid = Hash.new(0)

$x = 0
$y = 0
$steps = 0

def trace(vector, wire)
  direction = vector[0]
  mag = vector[1..-1].to_i

  dx = 0
  dy = 0

  case direction
  when 'U'
    dy = 1
  when 'D'
    dy = -1
  when 'L'
    dx = -1
  when 'R'
    dx = 1
  end

  mag.times do |i|
    $x += dx
    $y += dy
    mark($x, $y, wire)
  end
end

def mark(x, y, wire)
  case $grid[[x,y]]
  when nil
    $steps += 1
    $grid[[x,y]] = wire
    $steps_grid[[x,y]] = $steps
  when wire
  when 'both'
  else
    $steps += 1
    $grid[[x,y]] = 'both'
    $steps_grid[[x,y]] += $steps
  end
end

wire1.each { |vector| trace(vector, '2') }
$x = 0
$y = 0
$steps = 0
wire2.each { |vector| trace(vector, '1') }

keys = $grid.select { |k,v| v == 'both' }.keys
puts keys.map { |k| $steps_grid[k] }.min
