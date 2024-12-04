file = File.open(File.join(__dir__, 'input.txt'))
line = file.read

enabled = true
result = 0
line.scan(/don't\(\)|do\(\)|mul\(\d{1,3},\d{1,3}\)/).each do |cap|
  if cap.start_with?('mul(') && enabled
    result += cap.scan(/\d{1,3}/).map(&:to_i).reduce(:*)
    next
  end

  enabled = cap == 'do()'
end

puts result
