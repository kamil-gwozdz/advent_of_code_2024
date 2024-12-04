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

  # brute force because I'm lazy
  # remove one element at a time and check if the delta is good

  numbers.each_with_index do |n, i|
    new_numbers = numbers.dup
    new_numbers.delete_at(i)
    if good_delta?(new_numbers) && (all_increasing?(new_numbers) || all_decreasing?(new_numbers))
      result += 1
      break
    end
  end
end

puts result
