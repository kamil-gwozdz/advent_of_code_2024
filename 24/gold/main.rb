file = File.open(File.join(__dir__, "input.txt"))
lines = file.read.split("\n")

# require "bundler/inline"
# gemfile do
#   source "https://rubygems.org"
#   gem "dijkstra_fast"
# end

@gates = {}
@unsolved = []

lines.each do |line|
  if line.include?(": ")
    gate, value = line.split(": ")
    @gates[gate] = value == "1"
  end

  if line.include?(" -> ")
    # eg:
    # x00 AND y00 -> z00
    words = line.split(" ")

    @unsolved << [words[0], words[1], words[2], words[4]]
  end
end

until @unsolved.size == 0
  @unsolved.each do |input1, operation, input2, output|
    next if @gates[input1].nil? || @gates[input2].nil?

    result = case operation
             when "AND"
                @gates[input1] && @gates[input2]
             when "OR"
                @gates[input1] || @gates[input2]
             when "XOR"
                @gates[input1] ^ @gates[input2]
             end

    @gates[output] = result
    @unsolved.delete([input1, operation, input2, output])
  end
end

puts @gates.select{ |k, v| k.start_with?("z")}.sort.reverse.to_a.map(&:last).map{|v| v ? "1" : "0"}.join.to_i(2)
