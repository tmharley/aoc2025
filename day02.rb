def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = '11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124'

REAL_INPUT = import_from_file('day02_input.txt')

def check_range(min, max, reps = 2)
  invalid = Set.new
  num = min[0...(min.length / reps)].to_i
  while (check = (num.to_s * reps).to_i) <= max.to_i
    invalid << check if check >= min.to_i
    num += 1
  end
  invalid
end

def part_one(input)
  invalid = Set.new
  input.split(',').each do |range_string|
    min, max = range_string.split('-')
    invalid += check_range(min, max)
  end
  invalid.sum
end

def part_two(input)
  invalid = Set.new
  input.split(',').each do |range_string|
    min, max = range_string.split('-')
    (2..max.length).each do |i|
      invalid += check_range(min, max, i)
    end
  end
  invalid.sum
end

p part_one(TEST_INPUT) # should be 1227775554
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 4174379265
p part_two(REAL_INPUT)