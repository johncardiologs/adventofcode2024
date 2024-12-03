class InputParser
  attr_reader :left_list, :right_list

  def initialize(file_name)
    @file_name = file_name
    @left_list = []
    @right_list = []
  end

  def execute
    File.foreach(@file_name) { |report| parse_report(report) }
  end

  private

  def parse_report(report)
    first, second = report.split
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
    @right_hash = {}
    @right_hash.default = 0
    @right_list.each { |num| @right_hash[num] += 1 }

    compute_similarity
  end

  private

  def compute_similarity
    @left_list.reduce(0) do |similarity, num|
      next similarity if @right_hash[num] == 0 # instead of .nil? because we previously used .default(0)

      similarity + num * @right_hash[num]
    end
  end
end
