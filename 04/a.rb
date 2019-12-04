min = 136818
max = 685979

count = 0

min.upto(max) do |n|
  arr = n.to_s.split('').map(&:to_i)
  if (arr.sort == arr)
    group = arr.group_by {|x| x}.values
    if group.any? { |v| v.length > 1 }
      count += 1
    end
  end
end

puts count