# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Formatter
    module CsvTextMethods
      
      def tab
        ","
      end

      def line(number, line)
        line.sub!(/^#{tab}/, "#{number}#{tab}") if number
        line
      end

    end
  end
end
