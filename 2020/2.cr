require "file"

abstract class PasswordRule
  abstract def allows?(password : String) : Bool
end

class PasswordWithRule
  getter password : String
  getter rule : PasswordRule

  def initialize(@password, @rule)
  end

  def self.parse(string : String, password_rule_type : PasswordRule.class)
    rule_string, password_string = string.split ":"

    password = password_string.strip
    rule = password_rule_type.new rule_string.strip

    self.new password, rule
  end

  def allowed?
    rule.allows? password
  end
end

input = File.read_lines("2.in")

# --- Part 1 ---

class FirstPasswordRule < PasswordRule
  getter restriction_character : Char
  getter permissible_range : Range(Int32, Int32)

  def initialize(string : String)
    range_string, character_string = string.split " "

    @restriction_character = character_string.chars[0]

    range_min, range_max = range_string.split("-").map &.to_i

    @permissible_range = range_min..range_max
  end

  def allows?(password : String) : Bool
    permissible_range.includes? password.count(restriction_character)
  end
end

first_result = input.count { |line| PasswordWithRule.parse(line, FirstPasswordRule).allowed? }

p! first_result

# --- Part 2 ---

class SecondPasswordRule < PasswordRule
  getter restriction_character : Char
  getter permissible_indices : Array(Int32)

  def initialize(string : String)
    location_string, character_string = string.split " "

    @restriction_character = character_string.chars[0]

    @permissible_indices = location_string.split("-").map { |location| location.to_i - 1 }
  end

  def allows?(password : String) : Bool
    permissible_indices.one? { |index| password[index] == restriction_character }
  end
end

second_result = input.count { |line| PasswordWithRule.parse(line, SecondPasswordRule).allowed? }

p! second_result
