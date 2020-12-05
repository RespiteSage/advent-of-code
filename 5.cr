require "file"

input = File.read_lines("5.in")

# --- Part 1 ---

def seat_address_to_row_column(seat_address)
  row_address = seat_address[...7]
  row = row_address.gsub({'F' => '0', 'B' => '1'}).to_i(base: 2)

  column_address = seat_address[7..9]
  column = column_address.gsub({'L' => '0', 'R' => '1'}).to_i(base: 2)

  {row, column}
end

def seat_id(row, column)
  row * 8 + column
end

seat_locations = input.map { |line| seat_address_to_row_column line }

first_result = seat_locations.max_of { |(row, column)| seat_id row, column }

p! first_result

# --- Part 2 ---

ids = seat_locations.map { |(row, column)| seat_id row, column }

min_id = ids.min
max_id = first_result

second_result = (min_id..max_id).find { |id| !ids.includes? id }

p! second_result
