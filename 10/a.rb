$map = Hash.new(0)
$asteroid_field = File.open('input').readlines
$count_hash = Hash.new(0)

def count_visible(x, y)
  $asteroid_field.each_with_index do |row, j|
    row.split('').each_with_index do |location, i|
      next unless location == '#'
      next if (x == i) && (y == j)
      begin
        r = Rational(i-x,j-y)
      rescue ZeroDivisionError
        r = 'undefined'
      end
      $slopes[r] = $slopes[r] + [[i,j]]
    end
  end

  $count_hash[[x,y]] = $slopes.inject(0) do |sum, (k,v)|
    if k == 0
      sum += 1 if v.map(&:last).any? {|n| n > y }
      sum += 1 if v.map(&:last).any? {|n| n < y }
    else
      sum += 1 if v.map(&:first).any? {|n| n > x }
      sum += 1 if v.map(&:first).any? {|n| n < x }
    end
    sum
  end
end

$asteroid_field.each_with_index do |row, y|
  row.split('').each_with_index do |location, x|
    if location == '#'
      $slopes = Hash.new([])
      count_visible(x,y)
    end
  end
end

puts $count_hash.values.max
puts $count_hash.key($count_hash.values.max).inspect
