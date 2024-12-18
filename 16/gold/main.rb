file = File.open(File.join(__dir__, "input.txt"))
lines = file.read.split("\n")

require "bundler/inline"
gemfile do
  source "https://rubygems.org"
  gem "dijkstra_fast"
end

map = {}
start_point = nil
end_point = nil
lines.each_with_index do |line, line_idx|
  line.split("").each_with_index do |char, char_idx|
    map[[line_idx, char_idx]] = char
    if char == "S"
      start_point = [line_idx, char_idx]
      map[[line_idx, char_idx]] = "."
    elsif char == "E"
      end_point = [line_idx, char_idx]
      map[[line_idx, char_idx]] = "."
    end
  end
end

#   n
# w   e
#   s

graph = DijkstraFast::Graph.new
map.each_key do |(x, y)|
  graph.add([[x, y], "E"], [[x, y + 1], "E"], distance: 1) if map[[x, y]] == "." && map[[x, y + 1]] == "."
  graph.add([[x, y], "S"], [[x + 1, y], "S"], distance: 1) if map[[x, y]] == "." && map[[x + 1, y]] == "."
  graph.add([[x, y], "W"], [[x, y - 1], "W"], distance: 1) if map[[x, y]] == "." && map[[x, y - 1]] == "."
  graph.add([[x, y], "N"], [[x - 1, y], "N"], distance: 1) if map[[x, y]] == "." && map[[x - 1, y]] == "."

  graph.add([[x, y], "E"], [[x, y], "S"], distance: 1000) if map[[x, y]] == "."
  graph.add([[x, y], "S"], [[x, y], "W"], distance: 1000) if map[[x, y]] == "."
  graph.add([[x, y], "W"], [[x, y], "N"], distance: 1000) if map[[x, y]] == "."
  graph.add([[x, y], "N"], [[x, y], "E"], distance: 1000) if map[[x, y]] == "."

  graph.add([[x, y], "E"], [[x, y], "N"], distance: 1000) if map[[x, y]] == "."
  graph.add([[x, y], "N"], [[x, y], "W"], distance: 1000) if map[[x, y]] == "."
  graph.add([[x, y], "W"], [[x, y], "S"], distance: 1000) if map[[x, y]] == "."
  graph.add([[x, y], "S"], [[x, y], "E"], distance: 1000) if map[[x, y]] == "."
end

distance_n, path = graph.shortest_path([start_point, "E"], [end_point, "N"])
distance_s, path = graph.shortest_path([start_point, "E"], [end_point, "S"])
distance_w, path = graph.shortest_path([start_point, "E"], [end_point, "W"])
distance_e, path = graph.shortest_path([start_point, "E"], [end_point, "E"])

puts [distance_n, distance_s, distance_w, distance_e].min
