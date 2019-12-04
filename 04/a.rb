min = 136818
max = 685979

count = 0

min.upto(max) do |n|
  arr = n.to_s.split('').map(&:to_i)
  if (arr.sort == arr)
    if arr.uniq.length < arr.length
      count += 1
    end
  end
end

puts count