require "file"

input = File.read_lines("7.in")

# --- Part 1 ---

class ContainedByNode
  getter description : String
  getter contained_by = Set(ContainedByNode).new

  def initialize(@description)
  end
end

contained_by_map = Hash(String, ContainedByNode).new

input.each do |line|
  container_bag, contained_bags = line.split(" bags contain ")

  contained_by_map[container_bag] ||= ContainedByNode.new container_bag

  contained_bags.scan(/\d ([\w ]+) bags?/) do |match|
    contained_bag = match[1]

    contained_by_map[contained_bag] ||= ContainedByNode.new contained_bag

    contained_by_map[contained_bag].contained_by << contained_by_map[container_bag]
  end
end

all_containing_bags = Set(ContainedByNode).new
bags_to_process = Deque(ContainedByNode).new contained_by_map["shiny gold"].contained_by.to_a
until bags_to_process.empty?
  bag = bags_to_process.pop

  all_containing_bags << bag

  bags_to_process.concat (bag.contained_by - all_containing_bags)
end

first_result = all_containing_bags.size

p! first_result

# --- Part 2 ---

class ContainingNode
  getter description : String
  getter containing = Hash(ContainingNode, Int32).new

  def initialize(@description)
  end
end

container_map = Hash(String, ContainingNode).new

input.each do |line|
  container_bag, contained_bags = line.split(" bags contain ")

  container_map[container_bag] ||= ContainingNode.new container_bag

  contained_bags.scan(/(\d) ([\w ]+) bags?/) do |match|
    count = match[1].to_i
    contained_bag = match[2]

    container_map[contained_bag] ||= ContainingNode.new contained_bag

    container_map[container_bag].containing[container_map[contained_bag]] = count
  end
end

def count_total_bags(node : ContainingNode)
  if node.containing.empty?
    1
  else
    1 + node.containing.sum { |(node, count)| count * count_total_bags node }
  end
end

second_result = count_total_bags(container_map["shiny gold"]) - 1 # subtract our shiny gold bag

p! second_result
