def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = <<~INPUT
  123 328  51 64 
   45 64  387 23 
    6 98  215 314
  *   +   *   +  
INPUT

REAL_INPUT = import_from_file('day06_input.txt')

def find_problem_indices(input)
  result = []
  input.split('').each_with_index do |char, i|
    result << i unless char == ' '
  end
  result
end

def build_problems(input)
  lines = input.split("\n")
  indices = find_problem_indices(lines.last)
  problems = Array.new(indices.length)
  indices.each_with_index do |start, prob_num|
    problems[prob_num] = {
      operands: lines[...-1].map do |line|
        line[start..].match(/( ?)(\d+)/)[2].to_i
      end,
      operator: lines.last[start]
    }
  end
  problems
end

def part_one(input)
  problems = build_problems(input)
  problems.map do |p|
    p[:operands].reduce(p[:operator].to_sym)
  end.sum
end

def part_two(input)
  results = []
  buffer = []
  lines = input.split("\n")
  input_line_length = lines[0].length
  matrix = Array.new(input_line_length) { Array.new(lines.length) }
  lines.each_with_index do |line, i|
    line.split('').each_with_index do |char, j|
      matrix[j][i] = char
    end
  end
  matrix.reverse!
  indicies = find_problem_indices(lines.last.reverse)
  matrix.map! { |number| number.join('') }
  indicies.each do |i|
    matrix[i + 1] = matrix[i][-1]
    matrix[i][-1] = ''
  end
  matrix.map!(&:strip)
  matrix.each do |item|
    case item
    when '+', '*'
      results << buffer.reduce(item.to_sym)
      buffer.clear
    else
      buffer << item.to_i
    end
  end
  results.sum
end

p part_one(TEST_INPUT) # should be 4277556
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 3263827
p part_two(REAL_INPUT)