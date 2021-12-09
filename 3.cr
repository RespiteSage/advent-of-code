require "string_scanner"
require "math"

wires = File.read_lines("3.in").map(&.split ",")

# Solution

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

  def each_x_step_to(other_point)
    raise "Invalid use of each_x_step_to!" if (y != other_point.y)

    if self.x < other_point.x
      ((self.x + 1)..other_point.x).each { |x| yield Point.new x: x, y: self.y }
    elsif self.x > other_point.x
      (other_point.x..(self.x - 1)).reverse_each { |x| yield Point.new x: x, y: self.y }
    end
  end

  def each_y_step_to(other_point)
    raise "Invalid use of each_y_step_to!" if (x != other_point.x)

    if self.y < other_point.y
      ((self.y + 1)..other_point.y).each { |y| yield Point.new x: self.x, y: y }
    elsif self.y > other_point.y
      (other_point.y..(self.y - 1)).reverse_each { |y| yield Point.new x: self.x, y: y }
    end
  end
end

enum Axis
  X
  Y
end

record WireStep, delta : Int32, axis : Axis do
  def self.new(encoded_string)
    scanner = StringScanner.new encoded_string
    direction = scanner.scan(/[UDLR]/).not_nil!
    length = scanner.scan(/\d+/).not_nil!.to_i

    case direction
    when "U"
      axis = Axis::Y
      sign = 1
    when "D"
      axis = Axis::Y
      sign = -1
    when "L"
      axis = Axis::X
      sign = -1
    when "R"
      axis = Axis::X
      sign = 1
    else
      raise "Oops!"
    end

    WireStep.new delta: length * sign, axis: axis
  end
end

alias WireMap = Hash(Point, Int32)

def build_wiremap(wire_path)
  wire_map = WireMap.new
  current_point = Point.origin
  step_count = 0

  wire_path.each do |wire_step|
    case wire_step.axis
    when Axis::X
      next_point = current_point.translate x: wire_step.delta

      current_point.each_x_step_to(next_point) do |point|
        step_count += 1
        unless wire_map.has_key? point
          wire_map[point] = step_count
        end
      end
    when Axis::Y
      next_point = current_point.translate y: wire_step.delta

      current_point.each_y_step_to(next_point) do |point|
        step_count += 1
        unless wire_map.has_key? point
          wire_map[point] = step_count
        end
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

intersection_points = first_wire_map.keys & second_wire_map.keys

# --- Part 1 ---

closest_intersection = intersection_points.min_by { |point| point.manhattan_distance Point.origin }

p! closest_intersection
p! closest_intersection.manhattan_distance Point.origin

# --- Part 2 ---

closest_combined_distance = intersection_points.min_of? do |point|
  first_wire_map[point] + second_wire_map[point]
end

p! closest_combined_distance
