def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = import_from_file('day08_testinput.txt')
REAL_INPUT = import_from_file('day08_input.txt')

def distance(coord1, coord2)
  Math.sqrt((coord1[0] - coord2[0]) ** 2 + (coord1[1] - coord2[1]) ** 2 + (coord1[2] - coord2[2]) ** 2)
end

def build_junction_boxes(input)
  input.lines.map do |line|
    line.split(',').map(&:to_i)
  end
end

def process(input, num_connections = nil)
  junction_boxes = build_junction_boxes(input)
  distances = []
  connections = []
  junction_boxes.each_with_index do |a, i|
    junction_boxes.each_with_index do |b, j|
      next if i <= j
      distances << [i, j, distance(a, b)]
    end
  end
  distances.sort_by! {|d| d[2]}
  last_connection_x = nil
  distances.each_with_index do |c, idx|
    if num_connections.nil? || idx >= num_connections
      i = 0
      j = 1
      loop do
        break if i >= connections.length
        loop do
          j = i + 1 if j <= i
          break if j >= connections.length
          a = connections[i]
          b = connections[j]
          if (a & b).any?
            new_conn = a | b
            connections.delete(a)
            connections.delete(b)
            connections << new_conn
            j = 1
          else
            j += 1
          end
        end
        i += 1
        j = i + 1
      end
      unless num_connections.nil? && (connections.length != 1 || connections[0].length < junction_boxes.length)
        return [connections.map(&:length).max(3).reduce(:*), last_connection_x]
      end
    end
    connections << [c[0], c[1]]
    last_connection_x = [junction_boxes[c[0]][0], junction_boxes[c[1]][0]]
  end
  [connections.map(&:length).max(3).reduce(:*), last_connection_x]
end

def part_one(input, num_connections = nil)
  process(input, num_connections)[0]
end

def part_two(input, num_connections = nil)
  process(input)[1].reduce(:*)
end

p part_one(TEST_INPUT, 10) # should be 40
p part_one(REAL_INPUT, 1000)

p part_two(TEST_INPUT) # should be 25272
p part_two(REAL_INPUT)