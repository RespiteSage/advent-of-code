require "file"

input = File.read_lines("11.in")

# --- Part 1 ---

enum CellState
  Floor
  EmptySeat
  OccupiedSeat

  def self.from_char(char)
    case char
    when '.'
      Floor
    when 'L'
      EmptySeat
    when '#'
      OccupiedSeat
    else
      raise "Invalid cell state character '#{char}'!"
    end
  end
end

class SeatAutomaton
  ADJACENT_DELTAS = { {-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1} }

  getter state_array : Array(Array(CellState))
  property? stable : Bool = false

  def initialize(@state_array)
  end

  def width
    state_array.first.size
  end

  def height
    state_array.size
  end

  def step
    self.stable = true
    new_state = state_array.clone

    new_state.each_with_index do |row, row_index|
      row.each_with_index do |cell_value, column_index|
        adjacent_cell_values = adjacent_cells row_index, column_index

        occupied_adjacent_seat_count = adjacent_cell_values.count CellState::OccupiedSeat

        if (cell_value == CellState::EmptySeat) && (occupied_adjacent_seat_count == 0)
          new_state[row_index][column_index] = CellState::OccupiedSeat
          self.stable = false
        elsif (cell_value == CellState::OccupiedSeat) && (occupied_adjacent_seat_count >= 4)
          new_state[row_index][column_index] = CellState::EmptySeat
          self.stable = false
        end
      end
    end

    @state_array = new_state
  end

  def adjacent_cells(row_index, column_index)
    adj_cells = Array(CellState).new

    ADJACENT_DELTAS.each do |row_delta, column_delta|
      new_row_index = row_index + row_delta
      new_column_index = column_index + column_delta

      if (0...height).includes?(new_row_index) && (0...width).includes?(new_column_index)
        adj_cells << state_array[new_row_index][new_column_index]
      end
    end

    adj_cells
  end
end

automaton = SeatAutomaton.new input.map { |line| line.chars.map { |char| CellState.from_char char } }

until automaton.stable?
  automaton.step
end

first_result = automaton.state_array.sum &.count(CellState::OccupiedSeat)

p! first_result

# --- Part 2 ---

class VisionSeatAutomaton < SeatAutomaton
  def initialize(@state_array)
  end

  def step
    self.stable = true
    new_state = state_array.clone

    new_state.each_with_index do |row, row_index|
      row.each_with_index do |cell_value, column_index|
        visible_cell_values = visible_cells(row_index, column_index)
        occupied_visible_seat_count = visible_cell_values.count CellState::OccupiedSeat

        if (cell_value == CellState::EmptySeat) && (occupied_visible_seat_count == 0)
          new_state[row_index][column_index] = CellState::OccupiedSeat
          self.stable = false
        elsif (cell_value == CellState::OccupiedSeat) && (occupied_visible_seat_count >= 5)
          new_state[row_index][column_index] = CellState::EmptySeat
          self.stable = false
        end
      end
    end

    @state_array = new_state
  end

  def visible_cells(row_index : Int32, column_index : Int32)
    visible_cells = Array(CellState).new

    ADJACENT_DELTAS.each do |row_delta, column_delta|
      step_number = 1
      new_row_index = row_index + row_delta
      new_column_index = column_index + column_delta
      while ((0...height).includes?(new_row_index) && (0...width).includes?(new_column_index))
        cell_state = state_array[new_row_index][new_column_index]
        if (cell_state == CellState::EmptySeat) || (cell_state == CellState::OccupiedSeat)
          visible_cells << cell_state
          break
        end
        step_number += 1
        new_row_index = row_index + step_number * row_delta
        new_column_index = column_index + step_number * column_delta
      end
    end

    visible_cells
  end
end

automaton = VisionSeatAutomaton.new input.map { |line| line.chars.map { |char| CellState.from_char char } }

until automaton.stable?
  automaton.step
end

second_result = automaton.state_array.sum &.count(CellState::OccupiedSeat)

p! second_result
