# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License

module Cuporter
  module Formatters
    class Writer

      def initialize(report, output, number_scenarios)
        @report = report
        @output = output ? File.open(output, "w") : STDOUT
        @number_scenarios = number_scenarios
      end
    end
  end
end
