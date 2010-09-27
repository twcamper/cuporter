# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License

module Cuporter
  module Formatter
    class Writer

      def initialize(report, output, number_scenarios)
        @report = report
        @output = output ? File.open(output, "w") : STDOUT
        @number_scenarios = number_scenarios
      end

      def self.create(format, report, output, number_scenarios)
        klass = writer_class(format, report.class.name.split(/::/).last)
        klass.new(report.report_node, output, number_scenarios)
      end

      def self.writer_class(format, report_class)
        case format
        when /text|pretty/i
          Cuporter::Formatter::Text
        when /csv/i
          Cuporter::Formatter::Csv
        when /html/i
          Cuporter::Formatter.const_get("#{report_class}Html")
        end
      end
    end
  end
end
