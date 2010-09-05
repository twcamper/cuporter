# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Formatters
    module TextMethods
    
      def write(number_scenarios)
        @report.children.each do |tag_node|
          tag_node.number_all_descendants if number_scenarios
          write_node(tag_node, 0)
        end
      end

      def write_node(node, tab_stops)
        @output.puts "#{self.class::TAB * tab_stops}#{node.name}"
        node.children.each do |child|
          if child.has_children?
            write_node(child, tab_stops + 1)
          else
            @output.puts "#{self.class::TAB * tab_stops}#{self.class::TAB }#{child.name}"
          end
        end
      end
    end
  end
end
