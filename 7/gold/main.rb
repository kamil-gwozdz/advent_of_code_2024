file = File.open(File.join(__dir__, "input.txt"))
lines = file.read.split("\n")

map = {}
guard_chars = ["^", "v", "<", ">"]
current_position = nil

lines.each_with_index do |line, index|
  line.split("").each_with_index do |char, char_index|
    map[[index, char_index]] = char
    current_position = [index, char_index] if guard_chars.include?(char)
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
    return visited.size
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
  visited[next_position] = true
  move(map, next_position, visited)
end

puts move(map, current_position)
