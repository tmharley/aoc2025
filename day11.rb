def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = <<~INPUT
  aaa: you hhh
  you: bbb ccc
  bbb: ddd eee
  ccc: ddd eee fff
  ddd: ggg
  eee: out
  fff: out
  ggg: out
  hhh: ccc fff iii
  iii: out
INPUT

TEST_INPUT_2 = <<~INPUT
  svr: aaa bbb
  aaa: fft
  fft: ccc
  bbb: tty
  tty: ccc
  ccc: ddd eee
  ddd: hub
  hub: fff
  eee: dac
  dac: fff
  fff: ggg hhh
  ggg: out
  hhh: out
INPUT

REAL_INPUT = import_from_file('day11_input.txt')

def setup_devices(input)
  devices = {}
  input.lines.each do |line|
    name, output_strings = line.split(':')
    outputs = output_strings.strip.split(' ')
    devices[name] = {value: 0, outputs: outputs}
  end
  devices['out'] = {value: 0, outputs: nil}
  devices
end

def traverse(devices, label, destination = 'out', valid_list = nil)
  device = devices[label]
  device[:value] += 1
  return if label == destination
  device[:outputs].each do |output|
    next unless valid_list.nil? || valid_list.include?(output)
    traverse(devices, output, destination, valid_list)
  end
end

def num_paths(devices, start, finish)
  valid_list = Set.new << finish
  loop do
    num_valid = valid_list.length
    devices.each do |k, v|
      valid_list << k if v[:outputs]&.intersect?(valid_list.to_a)
    end
    break if valid_list.length == num_valid
  end
  traverse(devices, start, finish, valid_list)
  devices[finish][:value]
end

def part_one(input)
  devices = setup_devices(input)
  num_paths(devices, 'you', 'out')
end

def part_two(input)
  devices = setup_devices(input)
  main_nodes = %w[svr fft dac out]
  (1...main_nodes.length).map do |i|
    devices[main_nodes[i-1]][:value] = 0
    num_paths(devices, main_nodes[i-1], main_nodes[i])
  end.reduce(:*)
end

p part_one(TEST_INPUT) # should be 5
p part_one(REAL_INPUT)

p part_two(TEST_INPUT_2) # should be 2
p part_two(REAL_INPUT)