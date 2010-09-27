# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
require 'rubygems'
require 'builder'

module Cuporter
  module Formatter
    class HtmlNodeWriter

      attr_reader :builder

      def initialize
        @builder = Builder::XmlMarkup.new
      end

      def write_nodes(report, number_scenarios)
        report.report_node.children.each do |tag_node|
          write_node(tag_node)
        end
        builder
      end

      def write_node(node)
        builder.li(:class => node_class(node.name)) do
          write_node_name(node)
          write_children(node)
        end
      end

      def write_node_name(node)
        builder.span("#{node.number}.", :class => :number) if node.number
        builder.div(:class => "#{node_class(node.name)}_name") do
          builder.span(node.name)
          builder.span(node.file, :class => :file) if node.file
          builder.span("[#{node.total}]", :class => :total) if node_class(node.name) == :tag
        end
      end

      def write_children(node)
        return if node.children.empty?
        if node.is_a? ExampleSetNode
          write_children_in_table(node.children)
        else
          write_children_in_list(node.children)
        end
      end

      def write_children_in_table(children)
        builder.div(:class => :example_rows) do
          builder.table do
            builder.thead {to_row(children.first)}
            builder.tbody do
              children[1..-1].each do |child|
                to_row(child, :class => :example)
              end
            end
          end
        end
      end

      def to_row(node, attributes = {})
        builder.tr(attributes) do |row|
          number_string = node.number ? "#{node.number}." : ""
          row.td(number_string, :class => :number)
          node.name.sub(/^\|/,"").split("|").each {|s| row.td(s.strip, :class => :val) }
        end
      end

      def write_children_in_list(children)
        builder.ul do
          children.each do |child|
            if child.has_children?
              write_node(child)
            else
              builder.li() { write_node_name(child) }
            end
          end
        end
      end

      def node_class(name)
        case name
          when FeatureParser::TAG_LINE
            :tag
          when FeatureParser::FEATURE_LINE
            :feature
          when FeatureParser::SCENARIO_LINE
            :scenario
          when FeatureParser::SCENARIO_OUTLINE_LINE
            :scenario_outline
          when FeatureParser::SCENARIO_SET_LINE, FeatureParser::EXAMPLE_SET_LINE
            :example_set
          else
            :example
        end
      end

    end
  end
end
