file = File.open(File.join(__dir__, "input.txt"))
input = file.read.split("\n")

left = input.map{|x| x.split(" ").first.to_i }
right = input.map{|x| x.split(" ").last.to_i }

left.sort!
right.sort!

result = 0

[left, right].transpose.each do |l, r|
  result += (r - l).abs
end

puts result
