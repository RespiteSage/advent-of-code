require "file"

input = File.read_lines("9.in").map &.to_i64

# --- Part 1 ---

index = (25...input.size).find { |index| input[index - 25...index].each_combination(2).none? { |combo| combo.sum == input[index] } }.not_nil!

first_result = input[index]

p! first_result

# --- Part 2 ---

minmax = {-1, -1}
index = 0
until index == input.size || minmax != {-1, -1}
  run = [input[index]]

  last_index = index + 1
  while last_index < input.size && run.sum < first_result
    run << input[last_index]
    last_index += 1
  end

  if run.sum == first_result
    minmax = run.minmax
  end

  index += 1
end

second_result = minmax.sum

p! second_result
