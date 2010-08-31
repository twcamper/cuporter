# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
require 'rubygems'
require 'erb'
require 'builder'

module Cuporter
  module Formatters
    class Html < Writer

      NODE_CLASS = [:tag, :feature, :scenario, :example]

      def write_nodes
        @report.children.sort.each do |tag_node|
          write_node(tag_node, 0)
        end
        builder
      end

      def builder
        @builder ||= Builder::XmlMarkup.new
      end

      def write_node(node, indent_level)
        builder.li do |list_item|
          list_item.span(node.name, :class => NODE_CLASS[indent_level])
          if node.has_children?
            list_item.ul do |list|
              node.children.sort.each do |child|
                if child.has_children?
                  write_node(child, indent_level + 1)
                else
                  list.li(child.name, :class => NODE_CLASS[indent_level + 1])
                end
              end
            end
          end
        end
      end

      def get_binding
        binding
      end

      def rhtml
        ERB.new(RHTML)
      end

      def write
        @output.puts rhtml.result(get_binding).reject {|line| /^\s+$/ =~ line}
      end

  RHTML = %{
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Cucumber Tags</title>
    <style type="text/css"></style>
</head>
<body>
    <ul>
      <%= write_nodes%>
    </ul>
</body>
</html>
  }
  

    end
  end
end
