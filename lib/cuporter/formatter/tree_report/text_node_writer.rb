# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Formatter
    module TreeReport
      module TextNodeWriter

        def write
          @report.report_node.children.each do |child_node|
            write_node(child_node, 0)
          end
        end

      end
    end
  end
end
