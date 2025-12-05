def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = <<~INPUT
  3-5
  10-14
  16-20
  12-18
  
  1
  5
  8
  11
  17
  32
INPUT

REAL_INPUT = import_from_file('day05_input.txt')

def parse_input(input)
  range_strings, ingredient_strings = input.split("\n\n")
  ranges = range_strings.split("\n").map do |range_string|
    first, last = range_string.split('-')
    (first.to_i)..(last.to_i)
  end
  ingredients = ingredient_strings.split("\n").map(&:to_i)
  [ranges, ingredients]
end

def part_one(input)
  ranges, ingredients = parse_input(input)
  ingredients.select do |ingredient|
    ranges.any? { |range| range.include?(ingredient) }
  end.length
end

def part_two(input)
  ranges, _ = parse_input(input)
  ranges.uniq!
  combined_ranges = []
  done = false
  until done
    done = true
    ranges.each do |range|
      if (overlapping = combined_ranges.index {|cr| cr.overlap?(range)})
        new_range = ([range.min, combined_ranges[overlapping].min].min..[range.max, combined_ranges[overlapping].max].max)
        combined_ranges << new_range
        combined_ranges.delete_at(overlapping)
        done = false
      else
        combined_ranges << range
      end
    end
    ranges = combined_ranges
    combined_ranges = []
  end
  ranges.map(&:size).sum
end

p part_one(TEST_INPUT) # should be 3
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 14
p part_two(REAL_INPUT)