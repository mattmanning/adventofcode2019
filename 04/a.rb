min = 136818
max = 685979

count = 0

min.upto(max) do |n|
  arr = n.to_s.split('').map(&:to_i)
  if (arr.sort == arr) &&
    ((arr[0] == arr[1]) || (arr[1] == arr[2]) || (arr[2] == arr[3]) || (arr[3] == arr[4]) || (arr[4] == arr[5]))
    count += 1
  end
end

puts count