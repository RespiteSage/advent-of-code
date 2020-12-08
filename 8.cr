require "file"

input = File.read_lines("8.in")

# --- Part 1 ---

struct Instruction
  getter type : String
  getter value : Int32
  getter index : Int32

  def initialize(@type, @value, @index)
  end

  def self.from_line(line, current_index)
    instruction_type, value_string = line.split " "
    value = value_string.to_i

    new(instruction_type, value, current_index)
  end

  def next_instruction_index
    if type == "jmp"
      index + value
    else
      index + 1
    end
  end

  def acc_increment
    if type == "acc"
      value
    else
      0
    end
  end

  def clone
    Instruction.new(type, value, index)
  end
end

instructions = input.map_with_index { |line, index| Instruction.from_line line, index }

current_index = 0
acc = 0
previous_indices = Set(Int32).new
until previous_indices.includes? current_index
  previous_indices << current_index

  instruction = instructions[current_index]
  current_index = instruction.next_instruction_index
  acc += instruction.acc_increment
end

first_result = acc

p! first_result

# --- Part 2 ---

def flip_jmp_nop(instruction)
  if instruction.type == "jmp"
    Instruction.new "nop", instruction.value, instruction.index
  elsif instruction.type == "nop"
    Instruction.new "jmp", instruction.value, instruction.index
  else
    instruction
  end
end

working_flip = false
flip_index = 0
final_acc = nil
until working_flip || !instructions[flip_index]?
  instructions_clone = instructions.clone
  instructions_clone[flip_index] = flip_jmp_nop instructions_clone[flip_index]

  current_index = 0
  acc = 0
  previous_indices = Set(Int32).new
  until previous_indices.includes?(current_index) || !instructions_clone[current_index]?
    previous_indices << current_index

    instruction = instructions_clone[current_index]
    current_index = instruction.next_instruction_index
    acc += instruction.acc_increment
  end

  if current_index == instructions.size
    working_flip == true
    final_acc = acc
  end

  flip_index += 1
end

second_result = final_acc

p! second_result
