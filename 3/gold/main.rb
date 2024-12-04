file = File.open(File.join(__dir__, "input.txt"))
line = file.read

result = 0
line.scan(/mul\((\d{1,3}),(\d{1,3})\)/).each do |x,y|
  result += x.to_i * y.to_i
end

puts result
