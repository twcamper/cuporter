# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
require 'rubygems'
require 'builder'

module Cuporter
  module Formatters
    class HtmlNodeWriter

      attr_reader :builder

      NODE_CLASS = [:tag, :feature, :scenario, :example_set, :example]

      def initialize
        @builder = Builder::XmlMarkup.new
      end

      def write_nodes(report, number_scenarios)
        report.children.each do |tag_node|
          tag_node.number_all_descendants if number_scenarios
          write_node(tag_node, 0)
        end
        builder
      end

      def write_node(node, indent_level)
        builder.li(:class => NODE_CLASS[indent_level]) do
          write_node_name(node, indent_level)
          write_children(node.children, indent_level)
        end
      end

      def write_node_name(node, indent_level)
        builder.span("#{node.number}.", :class => :number) if node.number
        builder.span(node.name, :class => "#{NODE_CLASS[indent_level]}_name")
      end

      def write_children(children, indent_level)
        return if children.empty?
        builder.ul(:class => "#{NODE_CLASS[indent_level]}_children") do
          indent_level += 1
          children.each do |child|
            if child.has_children?
              write_node(child, indent_level)
            else
              builder.li(:class => :leaf) { write_node_name(child, indent_level) }
            end
          end
        end
      end

    end
  end
end
