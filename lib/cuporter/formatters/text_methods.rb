# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Formatters
    module TextMethods
    
      def write
        @report.children.each do |tag_node|
          write_node(tag_node, 0)
        end
      end

      def write_node(node, tab_stops)
        @output.puts "#{self.class::TAB * tab_stops}#{node.name}"
        node.children.each do |child|
          @output.puts "#{self.class::TAB + (self.class::TAB * tab_stops)}#{child.name}"
          child.children.each do |grand_child|
            if grand_child.has_children?
              write_node(grand_child, tab_stops + 2)
            else
              @output.puts "#{self.class::TAB * tab_stops}#{self.class::TAB * 2}#{grand_child.name}"
            end
          end
        end
      end
    
    end
  end
end
