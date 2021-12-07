require "file"

input = File.read_lines("2.in")

# Part 1

class SubmarineLocation
  property depth : Int32 = 0
  property distance : Int32 = 0

  def execute_command(command_type : SubmarineCommand, value : Int32)
    case command_type
    in SubmarineCommand::Up
      self.depth -= value
    in SubmarineCommand::Down
      self.depth += value
    in SubmarineCommand::Forward
      self.distance += value
    end
  end
end

enum SubmarineCommand
  Up
  Down
  Forward
end

parsed_input = input.map(&.split(" ")).map { |(command, value)| {SubmarineCommand.parse(command), value.to_i32} }

sub = SubmarineLocation.new

parsed_input.each { |(command, value)| sub.execute_command command, value }

first_result = sub.depth * sub.distance

p! first_result

# Part 2

class RevisedSubmarineLocation
  property depth : Int32 = 0
  property distance : Int32 = 0
  property aim : Int32 = 0

  def execute_command(command_type : SubmarineCommand, value : Int32)
    case command_type
    in SubmarineCommand::Up
      self.aim -= value
    in SubmarineCommand::Down
      self.aim += value
    in SubmarineCommand::Forward
      self.distance += value
      self.depth += aim * value
    end
  end
end

sub = RevisedSubmarineLocation.new

parsed_input.each { |(command, value)| sub.execute_command command, value }

second_result = sub.depth * sub.distance

p! second_result
