# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Formatter
    class Text < Writer
      include TextMethods

      def tab
        @tab ||= @number_scenarios ? "   " : "  "
      end

      COL_WIDTH = 5
      def line(number, line)
        if @number_scenarios
          number_string = number ? "#{number}." : ""
          number_field = number_string.rjust(COL_WIDTH, " ")
          line.sub!(/^\s{#{COL_WIDTH}}/, number_field)
        end
        line
      end

    end
  end
end
