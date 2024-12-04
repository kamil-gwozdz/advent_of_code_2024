file = File.open(File.join(__dir__, "input.txt"))
lines = file.read.split("\n")

def all_increasing?(numbers)
  numbers.each_cons(2).all? { |a, b| a < b && (a - b).abs <= 3 }
end

def all_decreasing?(numbers)
  numbers.each_cons(2).all? { |a, b| a > b && (a - b).abs <= 3 }
end

def good_delta?(numbers)
  numbers.each_cons(2).all? { |a, b| (a - b).abs <= 3 && (a - b).abs >= 1 }
end


result = 0

lines.each do |line|
  numbers = line.split(" ").map(&:to_i)

  result += 1 if good_delta?(numbers) && (all_increasing?(numbers) || all_decreasing?(numbers))
end

puts result
