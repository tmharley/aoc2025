def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = <<~INPUT
  7,1
  11,1
  11,7
  9,7
  9,5
  2,5
  2,3
  7,3
INPUT

REAL_INPUT = import_from_file('day09_input.txt')

def part_one(input)
  max_size = 0
  corners = input.lines.map do |line|
    line.split(',').map(&:to_i)
  end
  (0...corners.size).each do |i|
    ((i + 1)...corners.size).each do |j|
      size = ((corners[i][0] - corners[j][0]).abs + 1) * ((corners[i][1] - corners[j][1]).abs + 1)
      max_size = [size, max_size].max
    end
  end
  max_size
end

def cross?(seg1, seg2)
  if seg1[0][0] == seg1[1][0]
    return true if seg2[0][1] == seg2[1][1] && seg2[0][1] < [seg1[0][1], seg1[1][1]].max && seg2[0][1] > [seg1[0][1], seg1[1][1]].min && [seg2[0][0], seg2[1][0]].min < seg1[0][0] && [seg2[0][0], seg2[1][0]].max > seg1[0][0]
  else
    return true if seg2[0][0] == seg2[1][0] && seg2[0][0] < [seg1[0][0], seg1[1][0]].max && seg2[0][0] > [seg1[0][0], seg1[1][0]].min && [seg2[0][1], seg2[1][1]].min < seg1[0][1] && [seg2[0][1], seg2[1][1]].max > seg1[0][1]
  end
  false
end

def part_two(input)
  corners = input.lines.map { |line| line.split(',').map(&:to_i) }
  segments = (1...corners.size).map { |k| [corners[k-1], corners[k]] }
  max_size = 0
  (0...corners.size).each do |i|
    ((i + 1)...corners.size).each do |j|
      a = corners[i]
      b = corners[j]
      size = ((a[0] - b[0]).abs + 1) * ((a[1] - b[1]).abs + 1)
      rect_corners = [a, [a[0], b[1]], b, [b[0], a[1]]]
      rect_segments = [
        [a, rect_corners[1]],
        [rect_corners[1], b],
        [b, rect_corners[3]],
        [rect_corners[3], a]
      ]

      # do any of those segments intersect the larger shape?
      cross = false
      rect_segments.each do |r|
        segments.each do |s|
          cross ||= cross?(r, s)
          break if cross
        end
        break if cross
      end
      next if cross

      # are the opposite corners outside the shape?
      skip = false
      [1, 3].each do |k|
        rc = rect_corners[k]
        to_check = corners.select {|c| c[0] == rc[0]}
        if to_check.none? {|c| c[1] <= rc[1]}
          skip = segments.none? do |s|
            s[0][1] == s[1][1] && s[0][1] < rc[1] && [s[0][0], s[1][0]].min < rc[0] && [s[0][0], s[1][0]].max > rc[0]
          end
        end
        if to_check.none? {|c| c[1] >= rc[1]}
          skip ||= segments.none? do |s|
            s[0][1] == s[1][1] && s[0][1] > rc[1] && [s[0][0], s[1][0]].min < rc[0] && [s[0][0], s[1][0]].max > rc[0]
          end
        end
      end
      next if skip

      max_size = [size, max_size].max
    end
  end
  max_size
end

p part_one(TEST_INPUT) # should be 50
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 24
p part_two(REAL_INPUT) # currently does not produce correct result