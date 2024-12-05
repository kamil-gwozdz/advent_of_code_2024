file = File.open(File.join(__dir__, "input.txt"))
lines = file.read.split("\n")

constraints = []
all_pages = []
incorrect_pages = []

lines.each do |line|
  if line.include?("|")
    constraints << line.split("|").map(&:to_i)
  elsif line.include?(",")
    all_pages << line.split(",").map(&:to_i)
  end
end


all_pages.each do |pages|
  pages_index = {}
  pages.each_with_index do |page, index|
    pages_index[page] = index
  end

  constraints.each do |constraint|
    if pages_index[constraint[0]] && pages_index[constraint[1]] && pages_index[constraint[0]] > pages_index[constraint[1]]
      incorrect_pages << pages
      break
    end
  end
end

# constraints_map[x] represents all pages greater than x
constraints_map = {}
constraints.each do |constraint|
  constraints_map[constraint[0]] ||= Set.new
  constraints_map[constraint[0]] << constraint[1]
end

result = 0

incorrect_pages.each do |pages|
  pages.sort! do |x, y|
    if constraints_map[x]&.include?(y)
      -1
    elsif constraints_map[y]&.include?(x)
      1
    else
      0
    end
  end

  middle = pages[(pages.size-1) / 2]
  result += middle
end

puts result

