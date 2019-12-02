total = File.open('input').inject(0) do |sum, line|
  sum + (line.to_i / 3) - 2
end

puts total