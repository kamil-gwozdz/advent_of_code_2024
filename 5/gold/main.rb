file = File.open(File.join(__dir__, "input.txt"))
lines = file.read.split("\n")

constraints = []
all_pages = []

lines.each do |line|
  if line.include?("|")
    constraints << line.split("|").map(&:to_i)
  elsif line.include?(",")
    all_pages << line.split(",").map(&:to_i)
  end
end

result = 0

# TODO:
# - [ ] validate if all pages are different
# - [ ] validate if all pages have a middle (odd number of pages)

all_pages.each do |pages|
  pages_index = {}
  pages.each_with_index do |page, index|
    pages_index[page] = index
  end

  all_constraints_valid = true
  constraints.each do |constraint|
    if pages_index[constraint[0]] && pages_index[constraint[1]] && pages_index[constraint[0]] > pages_index[constraint[1]]
      all_constraints_valid = false
      break
    end
  end

  if all_constraints_valid
    middle = pages[(pages.size-1) / 2]
    result += middle
  end
end

puts result
