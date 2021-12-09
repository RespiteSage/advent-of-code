require "file"

input = File.read_lines("4.in")

# Part 1

class BingoBoard
  getter dimensions = [5, 5]
  getter board : Array(Int32)
  getter last_marked : Int32 = -1

  def initialize(@board = Array(Int32).new(dimensions.product(1), 0))
  end

  def [](x, y)
    board[y * dimensions[0] + x]
  end

  def []=(x, y, value)
    board[y * dimensions[0] + x] = value
  end

  def self.deserialize(board_string)
    board = self.new
    board_string.lines.each_with_index do |line, row_index|
      row = line.split(" ", remove_empty: true).map &.to_i

      row.each_with_index do |value, column_index|
        board[row_index, column_index] = value
      end
    end
    board
  end

  def mark(x, y)
    if self[x, y] >= 0
      @last_marked = self[x, y]
      self[x, y] = -self[x, y] - 1
    end
  end

  def mark(value)
    if i = board.index(value)
      mark i % dimensions[0], i // dimensions[0]
    end
  end

  def unmark(x, y)
    if self[x, y] < 0
      self[x, y] = -(self[x, y] + 1)
    end
  end

  def marked?(x, y)
    self[x, y] < 0
  end

  def bingo?
    rows = board.in_groups_of(dimensions[0], 0)
    columns = (0...dimensions[0]).map { |index| rows.map { |row| row[index] } }
    rows_and_columns = rows + columns

    rows_and_columns.any? { |path| path.all? { |value| value < 0 } }
  end

  def score
    board.sum { |value| value < 0 ? 0 : value } * last_marked
  end
end

def read_drawn_numbers(line)
  line.split(",").map &.to_i
end

sections = input.chunks { |line| line.empty? ? Enumerable::Chunk::Drop : true }.map { |(_, section)| section.join("\n") }

drawn_numbers = read_drawn_numbers sections.first

boards = sections[1..].map { |section| BingoBoard.deserialize section }

winning_indices = Array(Int32).new
drawn_numbers.each do |number|
  boards.each_with_index do |board, board_index|
    unless board.bingo?
      board.mark number
      if board.bingo?
        winning_indices << board_index
      end
    end
  end
end

first_result = boards[winning_indices.first].score

p! first_result

# Part 2

second_result = boards[winning_indices.last].score

p! second_result
