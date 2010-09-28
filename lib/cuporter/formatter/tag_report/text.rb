# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Formatter
    module TagReport
      class Text < Writer
        COL_WIDTH = 5
        MARGIN    = 0
        include TextMethods
        include PrettyTextMethods
        include Cuporter::Formatter::TagReport::TextNodeWriter
      end
    end
  end
end
