$orbits = File.open('input').inject({}) do |hsh, line|
  objects = line.strip.split(')')
  hsh.merge({ objects[1] => objects[0] })
end

def path(arr, obj)
  if obj == 'COM'
    arr + [obj]
  else
    path(arr + [obj], $orbits[obj])
  end
end

youpath = path([], 'YOU')
sanpath = path([], 'SAN')

youpath.each_with_index do |obj,i|
  if sanpath.detect {|o| o == obj}
    puts sanpath.index(obj) + i - 2
    exit
  end
end