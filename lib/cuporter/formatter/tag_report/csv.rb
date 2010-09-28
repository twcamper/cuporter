# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Formatter
    module TagReport
      class Csv < Writer
        include TextMethods
        include CsvTextMethods
        include Cuporter::Formatter::TagReport::TextNodeWriter
      end
    end
  end
end
