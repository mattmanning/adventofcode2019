$orbits = File.open('input').inject({}) do |hsh, line|
  objects = line.strip.split(')')
  hsh.merge({ objects[1] => objects[0] })
end

puts $orbits.inspect

def count(sum, obj)
  if obj == "COM"
    sum
  else
    count(sum+1, $orbits[obj])
  end
end

total = $orbits.inject(0) do |sum, (k,_v)|
  sum + count(0, k)
end

puts total