# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Formatter
    module PrettyTextMethods

      def tab
        @tab ||= @number_scenarios ? "   " : "  "
      end

      def line(number, empty_columns, name)
        line = empty_columns + name
        if @number_scenarios
          number_string = number ? "#{number}." : ""
          number_field = number_string.rjust(self.class::COL_WIDTH, " ")
          line.insert(0, " " * self.class::MARGIN).sub!(/^\s{#{self.class::COL_WIDTH}}/, number_field)
        end
        line
      end

    end
  end
end
