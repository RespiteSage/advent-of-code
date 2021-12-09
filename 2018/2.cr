require "math"

def differing_chars(first_string : String, second_string : String)
  difference_count = 0
  (0...Math.max(first_string.size, second_string.size)).each do |index|
    unless first_string[index]? && second_string[index]? && first_string[index]? == second_string[index]?
      difference_count += 1
    end
  end
  difference_count
end

inputs = File.read_lines "2.in"

two_count = 0
three_count = 0

inputs.each do |input|
  counts = input.chars.tally
  if counts.has_value? 2
    two_count += 1
  end

  if counts.has_value? 3
    three_count += 1
  end
end

puts "Two Count = #{two_count}"
puts "Three Count = #{three_count}"
puts "Checksum = #{two_count} * #{three_count} = #{two_count * three_count}"

similar_inputs : Tuple(String, String) = {"", ""}
common_letters = ""

inputs.each_combination(2) do |combo|
  if differing_chars(combo[0], combo[1]) <= 1
    similar_inputs = Tuple(String, String).from(combo)
    common_letters = combo[0].chars.select { |char| char.in_set? combo[1] }.join
    break
  end
end

puts "Similar Inputs: #{similar_inputs}"
puts "Common Letters: #{common_letters}"
