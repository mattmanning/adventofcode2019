lines = File.open('input').readlines
wire1 = lines[0].strip.split(',')
wire2 = lines[1].strip.split(',')

$grid = Hash.new

$x = 0
$y = 0

def trace(vector, wire)
  direction = vector[0]
  mag = vector[1..-1].to_i

  case direction
  when 'U'
    new_y = $y + mag
    $y.upto(new_y) { |i| mark($x, i, wire) }
    $y = new_y
  when 'D'
    new_y = $y - mag
    $y.downto(new_y) { |i| mark($x, i, wire) }
    $y = new_y
  when 'L'
    new_x = $x - mag
    $x.downto(new_x) { |i| mark(i, $y, wire) }
    $x = new_x
  when 'R'
    new_x = $x + mag
    $x.upto(new_x) { |i| mark(i, $y, wire) }
    $x = new_x
  end
end

def mark(x, y, wire)
  return if x == 0 && y == 0
  case $grid[[x,y]]
  when nil
    $grid[[x,y]] = wire
  when wire
  else
    $grid[[x,y]] = 'both'
  end
end

wire1.each { |vector| trace(vector, '1') }
$x = 0
$y = 0
wire2.each { |vector| trace(vector, '2') }

keys = $grid.select { |k,v| v == 'both' }.keys
key = keys.min { |a,b| (a.first.abs + a.last.abs) <=> (b.first.abs + b.last.abs) }
puts key.first.abs + key.last.abs