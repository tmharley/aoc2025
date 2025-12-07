def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = <<~INPUT
  .......S.......
  ...............
  .......^.......
  ...............
  ......^.^......
  ...............
  .....^.^.^.....
  ...............
  ....^.^...^....
  ...............
  ...^.^...^.^...
  ...............
  ..^...^.....^..
  ...............
  .^.^.^.^.^...^.
  ...............
INPUT

REAL_INPUT = import_from_file('day07_input.txt')

def parse_input(input)
  splitters = []
  lines = input.split("\n")
  start_x = lines.first.index('S')
  lines.each do |line|
    line_splitters = []
    line.chars.each_with_index do |char, index|
      line_splitters << index if char == '^'
    end
    splitters << line_splitters
  end
  [start_x, splitters, lines.first.length]
end

def part_one(input)
  start_x, splitters, _ = parse_input(input)
  splits = 0
  beams = [start_x]
  splitters.each do |line|
    beams.uniq!
    next if line.empty?
    line.each do |splitter|
      if beams.include?(splitter)
        splits += 1
        beams.delete(splitter)
        beams << splitter - 1
        beams << splitter + 1
      end
    end
  end
  splits
end

def part_two(input)
  start_x, splitters, width = parse_input(input)
  paths = Array.new(width) { 0 }
  paths[start_x] = 1
  splitters.each_with_index do |line, i|
    next if line.empty?
    new_paths = Array.new(width) { 0 }
    (0...paths.length).each do |j|
      if line.include?(j) # there's a splitter here
        new_paths[j - 1] += paths[j]
        new_paths[j + 1] += paths[j]
      else
        new_paths[j] += paths[j]
      end
    end
    paths = new_paths
  end
  paths.sum
end

p part_one(TEST_INPUT) # should be 21
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 40
p part_two(REAL_INPUT)