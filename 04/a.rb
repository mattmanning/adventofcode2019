min = 136818
max = 685979

count = 0

min.upto(max) do |n|
  arr = n.to_s.split('').map(&:to_i)
  if (arr.sort == arr) && arr.combination(2).any? { |c| c.uniq.length == 1 }
    count += 1
  end
end

puts count