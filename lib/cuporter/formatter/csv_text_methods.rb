# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Formatter
    module CsvTextMethods
      
      def tab
        ","
      end

      def line(number, empty_columns, name)
        empty_columns.sub!(/^#{tab}/, "#{number}#{tab}") if number
        name.gsub!(tab, ";")
        name.sub!(/^\|/, '')
        name.gsub!("|", tab)
        empty_columns + name
      end

    end
  end
end
