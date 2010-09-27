# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Formatter
    module TextMethods
    
      def write
        @report.report_node.children.each do |tag_node|
          tag_node.number_all_descendants if @number_scenarios
          write_node(tag_node, 0)
        end
      end

      def write_node(node, tab_stops)
        @output.puts line(node.number, "#{tab * tab_stops}#{node.name}")
        node.children.each do |child|
          if child.has_children?
            write_node(child, tab_stops + 1)
          else
            @output.puts line(child.number, "#{tab * tab_stops}#{tab }#{child.name}")
          end
        end
      end

    end
  end
end
