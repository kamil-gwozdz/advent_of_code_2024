file = File.open(File.join(__dir__, "input.txt"))
lines = file.read.split("\n")

require "bundler/inline"
gemfile do
  source "https://rubygems.org"
  gem "dijkstra_fast"
end

module HasKeypadMap
  def self.extended(base)
    base.const_set(:KEYBOARD_MAP, {})

    base::KEYBOARD.split("\n").each_with_index do |line, line_idx|
      line.split("").each_with_index do |char, char_idx|
        base::KEYBOARD_MAP[[line_idx, char_idx]] = char unless char == "."
      end
    end
  end
end

class Keypad
  attr_reader :start_column, :start_line, :current_column, :current_line, :path

  def initialize(start_line=nil, start_column=nil)
    if start_line.nil? && start_column.nil?
      start_line, start_column = value_to_coords("A")
    end

    @path = []

    if coords_to_value(start_line, start_column).nil?
      raise "Invalid start position"
    end

    build_graph

    @start_line = start_line
    @start_column = start_column

    @current_line = start_line
    @current_column = start_column
  end

  def shortest_path(value)
    finish_line, finish_column = value_to_coords(value)
    _distance, path = @graph.shortest_path([@current_line, @current_column], [finish_line, finish_column])

    # return "A" if distance == 0

    result_path = []

    path.each_cons(2) do |(line, column), (next_line, next_column)|
      if line == next_line - 1
        result_path << "v"
      elsif line == next_line + 1
        result_path << "^"
      elsif column == next_column - 1
        result_path << ">"
      elsif column == next_column + 1
        result_path << "<"
      else
        raise "Invalid path"
      end
    end

    result_path + ["A"]
  end

  def go_to(value)
    path = shortest_path(value)
    @current_column, @current_line = value_to_coords(value)
    @path += path
  end

  def value_to_coords(value)
    self.class::KEYBOARD_MAP.key(value)
  end

  def coords_to_value(line, column)
    self.class::KEYBOARD_MAP[[line, column]]
  end

  def self.value_to_coords(value)
    KEYBOARD_MAP.key(value)
  end

  def self.coords_to_value(line, column)
    KEYBOARD_MAP[[line, column]]
  end

  def self.map
    self::KEYBOARD_MAP
  end

  def map
    self.class.map
  end

  private

  def build_graph
    @graph = DijkstraFast::Graph.new

    map.each_key do |(x, y)|
      @graph.add([x, y], [x, y + 1], distance: 1) if !map[[x, y + 1]].nil?
      @graph.add([x, y], [x + 1, y], distance: 1) if !map[[x + 1, y]].nil?
      @graph.add([x, y], [x, y - 1], distance: 1) if !map[[x, y - 1]].nil?
      @graph.add([x, y], [x - 1, y], distance: 1) if !map[[x - 1, y]].nil?
    end
  end
end

# 789
# 456
# 123
# .0A
class Numpad < Keypad
  KEYBOARD = "789\n456\n123\n.0A"
  extend HasKeypadMap
end

class Arrowpad < Keypad
  KEYBOARD = ".^A\n<.>"
  extend HasKeypadMap
end


lines.each do |line|
  numpad = Numpad.new

  line.split("").each do |char|
    numpad.go_to(char)
  end

  puts numpad.path.inspect
end

