arr = File.open('input').readlines[0].strip.split('').map(&:to_i)

x = 25
y = 6

h = arr.each_slice(x*y).inject({}) do |hsh, s|
  zeros = s.count { |i| i.zero? }
  ones = s.count { |i| i == 1 }
  twos = s.count { |i| i == 2 }
  hsh.merge({zeros => (ones * twos)})
end

puts h[h.keys.min]