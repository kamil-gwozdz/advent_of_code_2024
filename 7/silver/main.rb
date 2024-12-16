require "bundler/inline"
gemfile do
  source 'https://rubygems.org'
  gem 'concurrent-ruby', require: 'concurrent'
end

file = File.open(File.join(__dir__, "input.txt"))
lines = file.read.split("\n")

map = {}
guard_chars = ["^", "v", "<", ">"]
starting_position = nil

lines.each_with_index do |line, index|
  line.split("").each_with_index do |char, char_index|
    map[[index, char_index]] = char
    starting_position = [index, char_index] if guard_chars.include?(char)
  end
end

def move(map, current_position, visited = {})
  direction = map[current_position]

  next_position = case direction
                  when "^"
                    [current_position[0] - 1, current_position[1]]
                  when "v"
                    [current_position[0] + 1, current_position[1]]
                  when "<"
                    [current_position[0], current_position[1] - 1]
                  when ">"
                    [current_position[0], current_position[1] + 1]
                  end

  if map[next_position].nil?
    return :out_of_map
  end

  if map[next_position] == "#"
    next_position = current_position
    direction = case direction
                when "^"
                  ">"
                when "v"
                  "<"
                when "<"
                  "^"
                when ">"
                  "v"
                end
  end

  map[next_position] = direction
  visited[next_position] ||= []

  if visited[next_position].include?(direction)
    return :loop
  end

  visited[next_position] << direction

  move(map, next_position, visited)
end


result = 0
pool = Concurrent::FixedThreadPool.new(25)
map.each_with_index do |(k, v), i|
  next unless v == "."

  pool.post do
    percent = i.to_f/map.size.to_f * 100
    puts "checking #{k} #{percent}% (#{i}/#{map.size})" if i % 100 == 0
    tmp_map = map.dup
    tmp_map[k] = "#"

    move_result = move(tmp_map, starting_position)
    result += 1 if move_result == :loop
  end
end

pool.shutdown
pool.wait_for_termination
puts result
