require "file"

input = File.read_lines("6.in")

# --- Part 1 ---

groups = input.chunks { |line| !line.empty? }.map(&.last).map { |group_chunk|
  group_chunk.flat_map(&.chars).to_set
}

first_result = groups.sum &.size

p! first_result

# --- Part 2 ---

groups = input.chunks { |line| !line.empty? }.map(&.last).map { |group_chunk|
  group_chunk.reduce(group_chunk[0].chars.to_set) { |acc, line| line.chars.to_set & acc }
}

second_result = groups.sum &.size

p! second_result
