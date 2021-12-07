require "file"

input = File.read_lines("3.in")

# Part 1

def binary_digit_sums(binary_strings)
  line_length = binary_strings.first.size
  binary_strings.reduce(Array(Int32).new(line_length, 0)) { |acc, string|
    digits = string.chars.map(&.to_i)

    digits.each_with_index do |digit, index|
      case digit
      when 0
        acc[index] -= 1
      when 1
        acc[index] += 1
      else
        raise "Invalid digit #{digit}!"
      end
    end

    acc
  }
end

def calc_gamma_epsilon(binary_strings)
  gamma_string = binary_digit_sums(binary_strings).map { |value| (value > 0) ? 1 : 0 }.join

  epsilon_string = gamma_string.tr("01", "10")

  {gamma_string.to_i(base: 2), epsilon_string.to_i(base: 2)}
end

gamma, epsilon = calc_gamma_epsilon input

first_result = gamma * epsilon

p! first_result

# Part 2

def find_rating(binary_strings)
  binary_strings = binary_strings.clone

  index = 0
  until binary_strings.size == 1
    digit_sums = binary_digit_sums binary_strings

    selected_value = yield digit_sums[index]

    binary_strings.select! { |string| string[index].to_i == selected_value }
    index += 1
  end

  binary_strings.first.to_i(base: 2)
end

oxygen_rating = find_rating(input) { |digit_sum| (digit_sum < 0) ? 0 : 1 }
scrubber_rating = find_rating(input) { |digit_sum| (digit_sum < 0) ? 1 : 0 }

second_result = oxygen_rating * scrubber_rating

p! second_result
