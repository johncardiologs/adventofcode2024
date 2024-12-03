class InputParser
  def initialize(file_name)
    @file_name = file_name
    @reports = []
  end

  def execute
    File.foreach(@file_name) { |report| parse_report(report) }
    @reports
  end

  private

  def parse_report(report)
    @reports.push(report.split.map(&:to_i))
  end
end

class Solver
  def initialize(parsed_reports)
    @reports = parsed_reports
  end

  def execute
    @reports.reduce(0) do |safety_score, report|
      idx = safety(report)
      next safety_score + 1 if idx == -1

      report.delete_at(idx)
      dampened_score = safety(report)
      dampened_score == -1 ? safety_score + 1 : safety_score
    end
  end

  private

  # returns -1 if safe, otherwise the index of a level we would like to dampen.
  def safety(report)
    throw new Exception if report.length < 2
    report_sign = sign(report[0] - report[1])

    report.each_with_index do |level, idx|
      next if idx == report.length - 1 # skip last level

      next_level = report[idx + 1]
      distance = level - next_level
      return idx + 1 if report_sign != sign(distance)

      report_sign = sign(distance)

      return idx + 1 if distance.abs < 1 || distance.abs > 3
    end

    -1
  end

  def sign(num)
    num <=> 0
  end
end
