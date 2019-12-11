PI = Math::PI
$point = [22,28]
def relative_polar(x,y, point)
  r = Math.hypot(point.last - y, x - point.first)
  theta = Math.atan2(point.last - y, x - point.first)
  theta = rotate(theta, PI/2)
  theta = rangify(theta)
  return r, theta
end

def rangify(theta)
  theta = 2*PI + theta if theta <= 0
  theta = theta - 2*PI if theta > 2*PI
  theta
end

def rotate(theta, rads)
  theta -= rads
  rangify(theta)
end

def relative_cartesian(r, theta)
  theta = rotate(theta, -PI/2)
  x = r * Math.cos(theta)
  y = r * Math.sin(theta)
  [$point.first+x.round, $point.last-y.round]
end

asteroid_field = File.open('input').readlines

theta_groups = Hash.new([])

asteroid_field.each_with_index do |row, y|
  row.split('').each_with_index do |location, x|
    next unless location == '#'
    next if (x == $point.first) && (y == $point.last)
    r, theta = relative_polar(x,y,$point)
    theta_groups[theta] = (theta_groups[theta] + [r]).sort
  end
end

zaps = 0
while true
  keys = theta_groups.keys.sort.reverse
  keys.each do |key|
    rad_arr = theta_groups[key]
    if rad_arr.empty?
      theta_groups.delete(key)
    else
      zapped = rad_arr.shift
      theta_groups[key] = rad_arr
      zaps += 1
    end
    if zaps == 200
      theta = key
      r = zapped
      carts = relative_cartesian(r, theta)  
      puts carts.first*100 + carts.last
      exit
    end
  end
end
