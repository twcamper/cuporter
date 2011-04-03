# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Formatter
    module TreeReport
      class Text < Writer
        
        COL_WIDTH = 6
        MARGIN    = 4
        include PrettyTextMethods
        include Cuporter::Formatter::NameReport::TextNodeWriter

        def write_node(node, tab_stops)
          @output.puts line(node.number, "#{tab * tab_stops}", "[#{node.total}] #{node.name}")
          node.children.each do |child|
            if child.has_children? and child.file.nil?
              write_node(child, tab_stops + 1)
            else
              @output.puts line(child.number, "#{tab * tab_stops}#{tab }", "[#{child.total}] #{child.file.split(File::SEPARATOR).last + ' ' if child.file}(#{child.name})")
            end
          end
        end

      end
    end
  end
end
