arr = File.open('input').readlines[0].strip.split('').map(&:to_i)

x = 25
y = 6
layer_size = x*y

black = 0
white = 1
clear = 2

layers = arr.each_slice(layer_size).to_a

disp_arr = (0..(layer_size-1)).map do |i|
  color = ' '
  layers.each do |l|
    case l[i]
    when black
      color = ' '
      break
    when white
      color = '*'
      break
    when clear
      color = ' '
    end
  end
  color
end

disp_arr.each_slice(x) do |s|
  puts s.join('')
end
