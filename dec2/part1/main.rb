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
      safety_score + (safety(report) ? 1 : 0)
    end
  end

  private

  def safe?(report)
    return false if report.length == 1

    report_sign = sign(report[0] - report[1])

    report.each_with_index do |level, idx|
      next if idx == report.length - 1 # skip last level

      next_level = report[idx + 1]
      distance = level - next_level
      return false if report_sign != sign(distance)

      report_sign = sign(distance)

      return false if distance.abs < 1 || distance.abs > 3
    end

    true
  end

  def sign(num)
    num <=> 0
  end
end
