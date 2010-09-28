# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Formatter
    module NameReport
      class Text < Writer
        
        COL_WIDTH = 6
        MARGIN    = 4
        include TextMethods
        include PrettyTextMethods
        include Cuporter::Formatter::NameReport::TextNodeWriter

      end
    end
  end
end
