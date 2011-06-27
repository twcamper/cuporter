# Copyright 2011 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Formatters

    module Util
      def terminal_width
        @@terminal_width ||= (`tput cols` || 120).to_i
      end

      def depth(node)
        node.parent.path.sub(/^.*\/report/, 'report').split('/').size#- 2
      end

    end

    module NodeFormatters
      class << self
        attr_accessor :total, :text_summary
      end

      def report(l, node)
        return l unless NodeFormatters.text_summary
        l += total(node)
        l += cuke_name(node['cuke_name'])
        l += title(node['title'])
        l
      end
      def dir(l, node)
        l += total(node)
        l += fs_name(node['fs_name'])
        l
      end
      def file(l, node)
        l += total(node)
        l += fs_name(node['fs_name'])
        l
      end
      def tag(l, node)
        l += total(node)
        l += cuke_name(node['cuke_name'])
        l
      end
      def feature(l, node)
        l += total(node)
        l += cuke_name(node['cuke_name'])
        l += tags(node['tags'])
        l += file_path(node['file_path'], l.size)
        l
      end
      def scenario(l, node)
        l += total_column_spacer
        l += number(node)
        l += cuke_name(node['cuke_name'])
        l += tags(node['tags'])
        l
      end
      def scenario_outline(l, node)
        l += total(node)
        l += cuke_name(node['cuke_name'])
        l += tags(node['tags'])
        l
      end
      def examples(l, node)
        l += total_column_spacer
        l += normal_indent(node)
        l += cuke_name(node['cuke_name'])
        l += tags(node['tags'])
        l
      end
      def example_header(l, node)
        l += total_column_spacer
        l += blank_for_number(node)
        l += example_name(node['cuke_name'])
        l += tags(node['tags'])
        l
      end
      def example(l, node)
        l += total_column_spacer
        l += number(node)
        l += example_name(node['cuke_name'])
        l += tags(node['tags'])
        l
      end

      def build_line(node)
        l = send(node.name.to_sym, "", node)
        l += "\n" unless l.empty?
        l
      rescue NoMethodError
        ""
      end
    end
    module Text
      extend Util
      extend NodeFormatters

      SPACER  = " "
      def tab_stop
        @@tab_stop ||= SPACER * 2
      end

      def total_column_spacer
        @@total_column_spacer ||= NodeFormatters.total ? tab_stop : ""
      end

      def total_column
        @@total_column ||= NodeFormatters.total  ? tab_stop * 2: ""
      end

      def total(node)
        format_number(node, 'total') do |indent_length, value|
          "[#{value}]".ljust(total_column.size, SPACER)
        end
      end

      def number(node)
        format_number(node, 'number') do |indent_length, value|
          "%#{tab_stop}#{indent_length}s " % "#{value}."
        end
      end

      def format_number(node, attr)
        d = depth(node)
        indent_length = d * tab_stop.size
        if ( value = node[attr])
          yield(indent_length, value)
        else
          tab_stop * d
        end
      end
      def blank_for_number(node)
        l = tab_stop * depth(node)
        l += SPACER if node.document.at("[@number]")
        l
      end
      def cuke_name(value)
        return "" unless value
        value.unescape_apostrophe
      end
      def fs_name(value)
        return "" unless value
        value.upcase
      end

      def tags(value)
        return "" unless value
        "#{tab_stop * 2}#{value}"
      end

      def file_path(value, line_size)
        return "" unless value
        "#{tab_stop}##{value}#{tab_stop * 2}".rjust(terminal_width - line_size)
      end

      def title(value)
        value || ""
      end

      def normal_indent(node)
        tab_stop * depth(node)
      end
      
      def example_name(value)
        cuke_name value
      end
      extend(Cuporter::Formatters::Text)
    end

  end
end
