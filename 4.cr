require "file"

input = File.read_lines("4.in")

# --- Part 1 ---

creds = input.chunk_while { |line| !line.empty? }.to_a.map { |cred_chunk|
  cred_chunk.join(" ").strip.split(" ").map(&.split(":")).to_h
}

desired_keys = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

first_result = creds.count { |cred| desired_keys.all? { |key| cred.has_key? key } }

p! first_result

# --- Part 2 ---

class ID
  private getter properties : Hash(String, String)

  def initialize(@properties)
  end

  def valid?
    byr_valid? && iyr_valid? && eyr_valid? && hgt_valid? && hcl_valid? && ecl_valid? && pid_valid?
  end

  def valid_year_in_range?(year_key, range)
    if year_string = properties[year_key]?
      if year = year_string.to_i?
        return range.includes? year
      end
    end
    false
  end

  def byr_valid?
    valid_year_in_range? "byr", (1920..2002)
  end

  def iyr_valid?
    valid_year_in_range? "iyr", (2010..2020)
  end

  def eyr_valid?
    valid_year_in_range? "eyr", (2020..2030)
  end

  def hgt_valid?
    if height_string = properties["hgt"]?
      if matches = height_string.match /^(\d+)(in|cm)$/
        value = matches[1].to_i? || -1
        unit = matches[2]

        if unit == "cm"
          return (150..193).includes? value
        end

        if unit == "in"
          return (59..76).includes? value
        end
      end
    end
    false
  end

  def hcl_valid?
    if hair_color_string = properties["hcl"]?
      return hair_color_string.matches? /^\#[0-9a-f]{6}$/
    end
    false
  end

  def ecl_valid?
    if eye_color_string = properties["ecl"]?
      return {"amb", "blu", "brn", "gry", "grn", "hzl", "oth"}.includes? eye_color_string
    end
    false
  end

  def pid_valid?
    if passport_id_string = properties["pid"]?
      if passport_id_string.size == 9 && passport_id_string.to_u64?
        return true
      end
    end
    false
  end
end

ids = creds.map { |cred| ID.new cred }

second_result = ids.count &.valid?

p! second_result
