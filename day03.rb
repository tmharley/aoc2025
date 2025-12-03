def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = <<~INPUT
  987654321111111
  811111111111119
  234234234234278
  818181911112111
INPUT

REAL_INPUT = import_from_file('day03_input.txt')

def parse_input(input)
  input.split("\n").map do |bank|
    bank.split('').map(&:to_i)
  end
end

def part_one(input)
  banks = parse_input(input)
  banks.map do |bank|
    first_battery = nil
    9.downto(1) do |i|
      first_battery = bank[...-1].index(i)
      break if first_battery
    end
    bank[first_battery] * 10 + bank[(first_battery + 1)..].max
  end.sum
end

def part_two(input)
  banks = parse_input(input)
  banks.map do |bank|
    value = 0
    cutoff = 0
    12.downto(1) do |i|
      first_battery = nil
      9.downto(1) do |j|
        first_battery = bank[cutoff..-i].index(j)
        break if first_battery
      end
      value = value * 10 + bank[cutoff + first_battery]
      cutoff += first_battery + 1
    end
    value
  end.sum
end

p part_one(TEST_INPUT) # should be 357
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 3121910778619
p part_two(REAL_INPUT)