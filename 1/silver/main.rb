file = File.open(File.join(__dir__, "input.txt"))
input = file.read.split("\n")

left = input.map{|x| x.split(" ").first.to_i }
right = input.map{|x| x.split(" ").last.to_i }

right_summary = right.tally

result = left.sum do |x|
  x * right_summary[x].to_i
end

puts result

