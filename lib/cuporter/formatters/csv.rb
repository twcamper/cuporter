# Copyright 2011 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Formatters

    module Csv
      extend Util
      extend NodeFormatters

      COMMA  = ","
      
      def tab_stop
        @@tab_stop ||= COMMA
      end

      def total_column_spacer
        @@total_column_spacer ||= NodeFormatters.total ? tab_stop : ""
      end

      def total_column
        @@total_column ||= total_column_spacer
      end

      def total(node)
        t = node['total'] ? "[#{node['total']}]," : COMMA
        "#{tab_stop * depth(node)}#{t}"
      end

      def number(node)
        n = node['number'] ? "#{node['number']})," : COMMA
        "#{tab_stop * depth(node)}#{n}"
      end

      def blank_for_number(node)
        "#{tab_stop * depth(node)},"
      end

      def cuke_name(value)
        "#{value ? value.unescape_apostrophe : nil},"
      end

      def fs_name(value)
        "#{value.upcase},"
      end

      def tags(value)
        return "" unless value
        "#{value},"
      end

      def file_path(value, length = nil)
        return "" unless value
        "#{value},"
      end

      def title(value)
        return "" unless value
        "#{value},"
      end

      def example_name(name)
        name.sub!(/^\s*\|/, '')
        name.sub!(/\|\s*$/, '')
        name.gsub(/\|/,";")
      end

      extend(Cuporter::Formatters::Csv)
    end
  end
end
