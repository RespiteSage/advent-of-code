masses = File.read_lines("1.in").map &.to_i

# --- Part 1 ---
def fuel_for_mass(mass)
  mass // 3 - 2
end

total_fuel = masses.sum { |mass| fuel_for_mass mass }

pp total_fuel

# --- Part 2 ---

def fuel_for_mass_plus_fuel(mass)
  fuel_mass = fuel_for_mass(mass)

  if fuel_mass <= 0
    0
  else
    fuel_mass + fuel_for_mass_plus_fuel(fuel_mass)
  end
end

total_fuel = masses.sum { |mass| fuel_for_mass_plus_fuel mass }

pp total_fuel
