def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = <<~INPUT
  ..@@.@@@@.
  @@@.@.@.@@
  @@@@@.@.@@
  @.@@@@..@.
  @@.@@@@.@@
  .@@@@@@@.@
  .@.@.@.@@@
  @.@@@.@@@@
  .@@@@@@@@.
  @.@.@@@.@.
INPUT

REAL_INPUT = import_from_file('day04_input.txt')

def surrounding_rolls(grid, y, x)
  total = 0
  (y-1..y+1).each do |yy|
    next if yy < 0 || yy >= grid.length
    (x-1..x+1).each do |xx|
      next if xx < 0 || xx >= grid[0].length || (yy == y && xx == x)
      total += 1 if grid[yy][xx] == '@'
    end
  end
  total
end

def part_one(input)
  total = 0
  grid = input.split("\n")
  grid.each_with_index do |row, y|
    (0...row.length).each do |x|
      total += 1 if row[x] == '@' && surrounding_rolls(grid, y, x) < 4
    end
  end
  total
end

def part_two(input)
  total = 0
  grid = input.split("\n")
  loop do
    removed_rolls = []
    grid.each_with_index do |row, y|
      (0...row.length).each do |x|
        if row[x] == '@' && surrounding_rolls(grid, y, x) < 4
          removed_rolls << [y, x]
        end
      end
    end
    removed_rolls.each do |y, x|
      grid[y][x] = '.'
    end
    if (num_removed = removed_rolls.length) == 0
      break
    else
      total += num_removed
    end
  end
  total
end

p part_one(TEST_INPUT) # should be 13
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 43
p part_two(REAL_INPUT)