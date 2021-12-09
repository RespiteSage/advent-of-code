inputs = File.read_lines "1.in"

inputs = inputs.map { |input| input.to_i }

frequency = inputs.sum

puts "Final Frequency: #{frequency}"

seen_frequencies = Hash(Int32, Bool).new
first_repeated_frequency : Int32? = nil
current_frequency = 0
inputs.cycle do |input|
  current_frequency += input
  if seen_frequencies.has_key? current_frequency
    first_repeated_frequency = current_frequency
    break
  else
    seen_frequencies[current_frequency] = true
  end
end

puts "First Repeated Frequency: #{first_repeated_frequency}"
