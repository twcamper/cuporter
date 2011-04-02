# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License

module Cuporter
  module Formatter

    class Writer

      attr_reader :number_scenarios

      def initialize(report, output, number_scenarios)
        @report = report
        @output = output ? File.open(output, "w") : STDOUT
        @number_scenarios = number_scenarios
      end

      def self.create(format, report, output, number_scenarios)
        klass = writer_class(format, report.class.name.split(/::/).last)
        klass.new(report, output, number_scenarios)
      end

      def self.writer_class(format, report_class)
        fmt = case format
        when /text|pretty/i 
          "Text"
        when /csv/i
          "Csv"
        when /html/i
          "Html"
        end
        Cuporter::Formatter.const_get(report_class).const_get(fmt)
      end
    end
  end
end
