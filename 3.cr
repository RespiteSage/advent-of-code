require "string_scanner"

wires = File.read_lines("3.in").map(&.split ",")

# --- Part 1 ---

record Point, x : Int32, y : Int32 do
  def self.origin
    new x: 0, y: 0
  end

  def manhattan_distance(to other_point)
    (self.x - other_point.x).abs + (self.y - other_point.y).abs
  end

  def translate(x = 0, y = 0)
    Point.new(
      x: self.x + x,
      y: self.y + y
    )
  end
end

enum Direction
  UP
  DOWN
  LEFT
  RIGHT
end

@[Flags]
enum Wires
  FIRST
  SECOND
end

record WireStep, length : Int32, direction : Direction do
  def self.new(encoded_string)
    scanner = StringScanner.new encoded_string
    direction = scanner.scan(/[UDLR]/).not_nil!
    length = scanner.scan(/\d+/).not_nil!.to_i

    case direction
    when "U"
      direction = Direction::UP
    when "D"
      direction = Direction::DOWN
    when "L"
      direction = Direction::LEFT
    when "R"
      direction = Direction::RIGHT
    else
      raise "Oops!"
    end

    WireStep.new length: length, direction: direction
  end
end

alias WireMap = Set(Point)

def build_wiremap(wire_path)
  wire_map = WireMap.new
  current_point = Point.origin

  wire_path.each do |wire_step|
    case wire_step.direction
    when Direction::UP
      next_point = current_point.translate y: wire_step.length

      ((current_point.y + 1)..next_point.y).each do |y|
        wire_map << Point.new current_point.x, y
      end
    when Direction::DOWN
      next_point = current_point.translate y: -wire_step.length

      (next_point.y...current_point.y).each do |y|
        wire_map << Point.new current_point.x, y
      end
    when Direction::LEFT
      next_point = current_point.translate x: -wire_step.length

      (next_point.x...current_point.x).each do |x|
        wire_map << Point.new x, current_point.y
      end
    when Direction::RIGHT
      next_point = current_point.translate x: wire_step.length

      ((current_point.x + 1)..next_point.x).each do |x|
        wire_map << Point.new x, current_point.y
      end
    else
      raise "Unreachable"
    end

    current_point = next_point
  end
  wire_map
end

wire_paths = wires.map(&.map { |step| WireStep.new step })

first_wire_map = build_wiremap(wire_paths[0])
second_wire_map = build_wiremap(wire_paths[1])

intersections = first_wire_map & second_wire_map

closest_intersection = intersections.min_by { |point| point.manhattan_distance Point.origin }

p! closest_intersection
p! closest_intersection.manhattan_distance Point.origin
