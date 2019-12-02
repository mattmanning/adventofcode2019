def mass(sum, remainder)
  remainder = (remainder / 3) - 2
  if remainder <= 0
    sum
  else
    mass(sum + remainder, remainder)
  end
end

total = File.open('input').inject(0) do |sum, line|
  sum + mass(0, line.to_i)
end

puts total