require "file"

input = File.read_lines("9.in").map &.to_i64

# --- Part 1 ---

index = (25...input.size).find { |index| input[index - 25...index].each_combination(2).none? { |combo| combo.sum == input[index] } }.not_nil!

first_result = input[index]

p! first_result

# --- Part 2 ---

minmax = {-1, -1}
input.each_index.find do |index|
  sum = 0
  run = input[index..].take_while { |value| (sum += value) <= first_result }

  if run.sum == first_result
    minmax = run.minmax
    true
  else
    false
  end
end

second_result = minmax.sum

p! second_result
