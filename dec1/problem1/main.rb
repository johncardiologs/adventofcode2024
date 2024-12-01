
class InputParser
  attr_reader :left_list
  attr_reader :right_list

  def initialize(file_name)
    @file_name = file_name
    @left_list = []
    @right_list = []
  end

  def execute
    File.foreach(@file_name) { |line| parse_line(line) }
  end

  private

  def parse_line(line)
    first, second = line.split
    @left_list.push(first.to_i)
    @right_list.push(second.to_i)
  end
end

class Solver
  def initialize(file_name)
    parser = InputParser.new(file_name)
    parser.execute
    @left_list = parser.left_list
    @right_list = parser.right_list
  end

  def execute
    @left_list.sort!
    @right_list.sort!

    if @left_list.length != @right_list.length
      throw new Exception("Different list lengths are not supported")
    end

    compute_distances
  end

  def compute_distances
    pairs = @left_list.zip(@right_list)
    pairs.map { |l, r| (r - l).abs }.reduce(&:+)
  end
end

