# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Formatter
    module TagReport
      module TextNodeWriter

        def write
          @report.report_node.children.each do |tag_node|
            tag_node.number_all_descendants if @number_scenarios
            write_node(tag_node, 0)
          end
        end

      end
    end
  end
end
