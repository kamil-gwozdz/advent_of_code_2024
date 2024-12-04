file = File.open(File.join(__dir__, "input.txt"))
lines = file.read.split("\n")
map = lines.map { |l| l.split("") }

result = 0

# horizontal
lines.each do |line|
  result += line.scan(/XMAS/).size
  result += line.scan(/SAMX/).size
end

# vertical
map.transpose.map(&:join).each do |line|
  result += line.scan(/XMAS/).size
  result += line.scan(/SAMX/).size
end

# diagonal upper left to lower right and reverse
padding = [*0..(map.length - 1)].map { |i| [nil] * i }
padded = padding.reverse.zip(map).zip(padding).map(&:flatten)
padded.transpose.map(&:compact).map(&:join).each do |line|
  result += line.scan(/XMAS/).size
  result += line.scan(/SAMX/).size
end

# diagonal lower left to  upper right and reverse
padding = [*0..(map.transpose.map(&:reverse).length - 1)].map { |i| [nil] * i }
padded = padding.reverse.zip(map.transpose.map(&:reverse)).zip(padding).map(&:flatten)
padded.transpose.map(&:compact).map(&:join).each do |line|
  result += line.scan(/XMAS/).size
  result += line.scan(/SAMX/).size
end

puts result
