require "file"

input = File.read_lines("10.in").map &.to_i

# --- Part 1 ---

input.sort!

# add socket and device
input.unshift 0
input.push (input.last + 3)

difference_counts = Hash(Int32, Int32).new(default_value: 0)

p! input.first

input.each_cons_pair do |a, b|
  difference_counts[b - a] += 1
end

first_result = difference_counts[1] * difference_counts[3]

p! first_result

# --- Part 2 ---

class AdapterNode
  getter joltage : Int32
  getter possible_output_indices = Array(Int32).new

  def initialize(@joltage)
  end

  def count_paths_to_joltage(desired_joltage)
    if joltage == desired_joltage
      return 1_u64
    end

    possible_outputs.sum(0_u64) { |node| node.count_paths_to_joltage(desired_joltage) }
  end
end

nodes = input.map { |joltage| AdapterNode.new joltage }

nodes.each_with_index do |node, index|
  next_node_index = index
  next_node = node
  while (next_node_index += 1) < nodes.size && (next_node = nodes[next_node_index]).joltage <= (node.joltage + 3)
    node.possible_outputs << next_node
  end
end

adapter = nodes.first
device = nodes.last

second_result = adapter.count_paths_to_joltage device.joltage

p! second_result
