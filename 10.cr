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

class AdapterPathCounter
  getter joltage : Int32
  property paths_to_adapter : Int64 = 0i64

  def initialize(@joltage)
  end
end

adapters = input.map { |joltage| AdapterPathCounter.new joltage }

adapters.first.paths_to_adapter = 1

adapters.each_with_index do |adapter, index|
  next_adapter_index = index
  next_adapter = adapter
  while (next_adapter_index += 1) < adapters.size && (next_adapter = adapters[next_adapter_index]).joltage <= (adapter.joltage + 3)
    next_adapter.paths_to_adapter += adapter.paths_to_adapter
  end
end

adapter = adapters.first
device = adapters.last

second_result = device.paths_to_adapter

p! second_result
