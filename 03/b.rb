lines = File.open('input').readlines
wire1 = lines[0].strip.split(',')
wire2 = lines[1].strip.split(',')

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
  $steps += 1
  case $grid[[x,y]]
  when nil
    $grid[[x,y]] = wire
    $steps_grid[[x,y]] = $steps
  when wire
  when 'both'
  else
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
