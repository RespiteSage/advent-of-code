instructions = File.read("2.in").split(",").map &.to_i

# --- Part 1 ---

enum ProgramState
  Continue
  Halt
end

class IntCodeState
  property mem : Array(Int32)
  property pos : Int32 = 0
  property state : ProgramState = ProgramState::Continue

  def initialize(@mem)
  end
end

def execute_add(ics)
  left = ics.mem[ics.mem[ics.pos + 1]]
  right = ics.mem[ics.mem[ics.pos + 2]]
  ics.mem[ics.mem[ics.pos + 3]] = left + right

  ics.pos += 4
end

def execute_multiply(ics)
  left = ics.mem[ics.mem[ics.pos + 1]]
  right = ics.mem[ics.mem[ics.pos + 2]]
  ics.mem[ics.mem[ics.pos + 3]] = left * right

  ics.pos += 4
end

def consume_instruction(ics)
  case ics.mem[ics.pos]
  when 1
    execute_add ics
  when 2
    execute_multiply ics
  when 99
    ics.state = ProgramState::Halt
  else
    raise "Invalid instruction!"
  end
end

modified_instructions = instructions.clone
modified_instructions[1] = 12
modified_instructions[2] = 2

program_state = IntCodeState.new modified_instructions

until program_state.state == ProgramState::Halt || program_state.pos >= program_state.mem.size
  consume_instruction(program_state)
end

p! program_state.pos
p! program_state.mem[0]

# --- Part 2 ---

noun = nil
verb = nil

(0..99).each do |n|
  (0..99).each do |v|
    modified_instructions = instructions.clone
    
    program_state = IntCodeState.new modified_instructions
    program_state.mem[1] = n
    program_state.mem[2] = v

    until program_state.state == ProgramState::Halt || program_state.pos >= program_state.mem.size
      consume_instruction(program_state)
    end

    if program_state.mem[0] == 19690720
      noun = n
      verb = v
    end
  end
  if noun
    break
  end
end

p! noun
p! verb
p! 100 * noun + verb unless noun.nil? || verb.nil?
