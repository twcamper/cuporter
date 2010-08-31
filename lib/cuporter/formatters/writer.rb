# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License

module Cuporter
  module Formatters
    class Writer

      def initialize(report, output)
        @report = report
        if output
          @output = File.open(output, "w")
        else
          @output = STDOUT
        end
      end
    end
  end
end
