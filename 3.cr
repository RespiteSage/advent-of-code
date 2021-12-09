require "file"

input = File.read_lines("3.in")

# --- Part 1 ---

class CircularArray(T)

  private property internal_array : Array(T)

  def initialize(@internal_array = Array(T).new)
  end

  def size
    internal_array.size
  end

  def [](index)
    internal_array.unsafe_fetch(index % size)
  end
end

line_patterns = input.map { |line| CircularArray(Char).new line.chars }

tree_count = 0
line_patterns.each_with_index do |pattern, index|
  if pattern[index * 3] == '#'
    tree_count += 1
  end
end

first_result = tree_count

p! first_result

# --- Part 2 ---

second_result = [{1, 1}, {1, 3}, {1, 5}, {1, 7}, {2, 1}].product(1_i64) do |(down, right)|
  tree_count = 0
  line_patterns.each_with_index do |pattern, line_index|
    if line_index.divisible_by?(down) && pattern[(line_index / down).to_i * right] == '#'
      tree_count += 1
    end
  end
  p! tree_count
  tree_count
end

p! second_result
