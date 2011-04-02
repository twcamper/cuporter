# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Formatter
    module TreeReport
      class Csv < Writer
        include TextMethods
        include CsvTextMethods
        include Cuporter::Formatter::NameReport::TextNodeWriter
      end
    end
  end
end
