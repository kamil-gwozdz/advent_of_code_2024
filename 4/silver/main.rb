file = File.open(File.join(__dir__, 'input.txt'))
input = file.read


regexes = []

width = input.split("\n").first.size

(0..(width-3)).each do |i|
  before_newline = i
  after_newline = width - i - 3 # 3 = width of the string we're looking for

  regex_str = <<~TXT.strip
    (?=(M.S.{#{before_newline}}
    .{#{after_newline}}.A..{#{before_newline}}
    .{#{after_newline}}M.S))
  TXT
  regexes << Regexp.new(regex_str)

  regex_str = <<~TXT.strip
    (?=(S.M.{#{before_newline}}
    .{#{after_newline}}.A..{#{before_newline}}
    .{#{after_newline}}S.M))
  TXT
  regexes << Regexp.new(regex_str)

  regex_str = <<~TXT.strip
    (?=(M.M.{#{before_newline}}
    .{#{after_newline}}.A..{#{before_newline}}
    .{#{after_newline}}S.S))
  TXT
  regexes << Regexp.new(regex_str)

  regex_str = <<~TXT.strip
    (?=(S.S.{#{before_newline}}
    .{#{after_newline}}.A..{#{before_newline}}
    .{#{after_newline}}M.M))
  TXT
  regexes << Regexp.new(regex_str)
end

result = 0
regexes.each do |regex|
  result += input.scan(regex).size
end

puts result
