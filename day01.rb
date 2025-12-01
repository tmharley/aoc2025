def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = <<~INPUT
  L68
  L30
  R48
  L5
  R60
  L55
  L1
  L99
  R14
  L82
INPUT

REAL_INPUT = import_from_file('day01_input.txt')

def rotate(start, direction, amount)
  case direction
  when 'R'
    (start + amount)
  when 'L'
    (start - amount)
  else
    raise 'Invalid direction'
  end
end

def part_one(input)
  zeroes = 0
  position = 50
  input.split("\n").map(&:chomp).each do |line|
    direction = line[0]
    amount = line[1..].to_i
    position = rotate(position, direction, amount) % 100
    zeroes += 1 if position.zero?
  end
  zeroes
end

def part_two(input)
  zeroes = 0
  position = 50
  input.split("\n").map(&:chomp).each do |line|
    direction = line[0]
    amount = line[1..].to_i
    new_position = rotate(position, direction, amount)
    # Add a million to everything in calculations to avoid weirdness
    # with integer division on negative numbers
    zeroes += ((new_position + 1_000_000) / 100 - (position + 1_000_000) / 100).abs
    # Also deal with weirdness when turning the dial left
    # and either starting or ending on zero
    zeroes -= 1 if (position % 100).zero? && new_position < position
    zeroes += 1 if (new_position % 100).zero? && new_position < position
    position = new_position
  end
  zeroes
end

p part_one(TEST_INPUT) # should be 3
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 6
p part_two(REAL_INPUT)