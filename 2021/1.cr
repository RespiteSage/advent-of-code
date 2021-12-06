require "file"

input = File.read_lines("1.in").map &.to_i32

# Part 1

answer_one = input.each.cons_pair.sum { |(first, second)| (second > first) ? 1 : 0 }

p! answer_one

# Part 2

answer_two = input.each.cons(3).map(&.sum).cons_pair.select { |(first, second)| second > first }.size

p! answer_two
