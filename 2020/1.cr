require "file"

input = File.read_lines("1.in").map &.to_i32

# --- Part 1 ---

combos = input.combinations(2)

summing_combos = combos.select { |combo| combo.sum == 2020 }

puts summing_combos

if summing_combos.size != 1
  raise "Need exactly one summing combo!"
end

summing_combo = summing_combos.first

p! result = summing_combo.product

# --- Part 2 ---

combos = input.combinations(3)

summing_combos = combos.select { |combo| combo.sum == 2020 }

puts summing_combos

if summing_combos.size != 1
  raise "Need exactly one summing combo!"
end

summing_combo = summing_combos.first

p! result = summing_combo.product
