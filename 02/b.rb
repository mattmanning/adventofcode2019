str = File.open('input').readlines[0].strip

0.upto(99) do |noun|
  0.upto(99) do |verb|

    arr = str.split(',').map(&:to_i)

    pos = 0
    arr[1] = noun
    arr[2] = verb

    while arr[pos] != 99 do
      if arr[pos] == 1
        arr[arr[pos+3]] = arr[arr[pos+1]] + arr[arr[pos+2]]
      elsif arr[pos] == 2
        arr[arr[pos+3]] = arr[arr[pos+1]] * arr[arr[pos+2]]
      end
      pos += 4
    end

    if arr[0] == 19690720
      puts 100 * noun + verb
      exit
    end
  end
end