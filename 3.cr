require "string_scanner"

struct FabricClaim
  getter id : Int32
  getter top : Int32
  getter left : Int32
  getter width : Int32
  getter height : Int32

  def initialize(definition : String)
    scanner = StringScanner.new definition
    scanner.skip(/#/)
    @id = scanner.scan(/\d+/).not_nil!.to_i
    scanner.skip(/ @ /)
    @left = scanner.scan(/\d+/).not_nil!.to_i
    scanner.skip(/,/)
    @top = scanner.scan(/\d+/).not_nil!.to_i
    scanner.skip(/: /)
    @width = scanner.scan(/\d+/).not_nil!.to_i
    scanner.skip(/x/)
    @height = scanner.scan(/\d+/).not_nil!.to_i
  end

  def right
    self.left + self.width
  end

  def bottom
    self.top + self.height
  end
end

inputs = File.read_lines "3.in"

claims = inputs.map { |input| FabricClaim.new input }

claim_surface = Hash(Tuple(Int32, Int32), Int32).new

claims.each do |claim|
  (claim.top...claim.bottom).each do |y|
    (claim.left...claim.right).each do |x|
      claim_surface[{y, x}] = claim_surface.fetch({y, x}, 0) + 1
    end
  end
end

total_overlap = claim_surface.count { |(key, value)| value > 1 }

puts "Total Overlap: #{total_overlap}"

nonoverlapping_claim_id = -1

claims.each do |claim|
  overlapping = false
  (claim.top...claim.bottom).each do |y|
    (claim.left...claim.right).each do |x|
      if claim_surface[{y, x}] > 1
        overlapping = true
        break
      end
    end
    break if overlapping == true
  end
  nonoverlapping_claim_id = claim.id if overlapping == false
end

puts "Nonoverlapping Claim: #{nonoverlapping_claim_id}"
