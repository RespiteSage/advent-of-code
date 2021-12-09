require "file"

input = File.read_lines("12.in")

# --- Part 1 ---

enum CardinalDirection
  North
  East
  South
  West

  def quarter_turn_clockwise
    case self
    in North
      East
    in East
      South
    in South
      West
    in West
      North
    end
  end

  def quarter_turn_counterclockwise
    case self
    in North
      West
    in East
      North
    in South
      East
    in West
      South
    end
  end
end

class Ship
  property heading : CardinalDirection = CardinalDirection::East
  property northing : Int32 = 0
  property easting : Int32 = 0

  def follow_instruction(instruction_string)
    instruction_type_char = instruction_string.chars.first
    value = instruction_string[1..].to_i

    case instruction_type_char
    when 'N'
      self.northing += value
    when 'S'
      self.northing -= value
    when 'E'
      self.easting += value
    when 'W'
      self.easting -= value
    when 'L'
      turn_left value
    when 'R'
      turn_right value
    when 'F'
      move_forward value
    else
      raise "Unreachable!"
    end
  end

  def turn_left(value)
    quarter_turns = value // 90

    quarter_turns.times do
      self.heading = self.heading.quarter_turn_counterclockwise
    end
  end

  def turn_right(value)
    quarter_turns = value // 90

    quarter_turns.times do
      self.heading = self.heading.quarter_turn_clockwise
    end
  end

  def move_forward(value)
    case heading
    in CardinalDirection::North
      self.northing += value
    in CardinalDirection::South
      self.northing -= value
    in CardinalDirection::East
      self.easting += value
    in CardinalDirection::West
      self.easting -= value
    end
  end
end

ship = Ship.new

input.each { |line| ship.follow_instruction line }

first_result = ship.northing.abs + ship.easting.abs

p! first_result

# --- Part 2 ---

class WaypointShip
  property northing : Int32 = 0
  property easting : Int32 = 0
  property waypoint_northing : Int32 = 1
  property waypoint_easting : Int32 = 10

  def follow_instruction(instruction_string)
    instruction_type_char = instruction_string.chars.first
    value = instruction_string[1..].to_i

    case instruction_type_char
    when 'N'
      self.waypoint_northing += value
    when 'S'
      self.waypoint_northing -= value
    when 'E'
      self.waypoint_easting += value
    when 'W'
      self.waypoint_easting -= value
    when 'L'
      rotate_waypoint_left value
    when 'R'
      rotate_waypoint_right value
    when 'F'
      move_forward_to_waypoint value
    else
      raise "Unreachable!"
    end
  end

  def rotate_waypoint_left(angle_degrees)
    quarter_turns = angle_degrees // 90

    quarter_turns.times do
      tmp = self.waypoint_easting
      self.waypoint_easting = -self.waypoint_northing
      self.waypoint_northing = tmp
    end
  end

  def rotate_waypoint_right(angle_degrees)
    quarter_turns = angle_degrees // 90

    quarter_turns.times do
      tmp = self.waypoint_easting
      self.waypoint_easting = self.waypoint_northing
      self.waypoint_northing = -tmp
    end
  end

  def move_forward_to_waypoint(repetitions)
    self.easting += repetitions * waypoint_easting
    self.northing += repetitions * waypoint_northing
  end
end

waypoint_ship = WaypointShip.new

test_input = ["F10", "N3", "F7", "R90", "F11"]

input.each { |line| waypoint_ship.follow_instruction line }

second_result = waypoint_ship.northing.abs + waypoint_ship.easting.abs

p! second_result
