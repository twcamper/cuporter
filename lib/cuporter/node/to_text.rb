# Copyright 2011 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Node

    module ToText
      def tab_stop
        @@tab_stop ||= '  '
      end
      def depth
        d = parent.path.sub(/^.*\/report/, 'report').split('/').size#- 2
      end

      def to_text(options = {})
        s = ""
        s = text_line(self['cuke_name']) if self['cuke_name']
        s += children.map {|n| n.to_text}.to_s
        s
      end
      alias :to_pretty :to_text

      def indent
        total_col + (tab_stop * depth)
      end

      def total_col
        @@total_col ||= Cuporter.options[:total] ? tab_stop * 2 : ""
      end

      def terminal_width
        @@terminal_width ||= (`tput cols` || 120).to_i
      end

      def text_line(name)
        l = indent
        l += name
        l += "#{tab_stop * 2}#{self['tags']}" if self['tags']
        
        if self['file']
          l += "#{tab_stop}##{self['file']}#{tab_stop * 2}".rjust(terminal_width - l.size)
        end
        l += "\n"
        l
      end

      module TotalFormatter
        def total_col
          if (total = self['total'])
            "% 4s " % "[#{total}]"
          else
            super
          end
        end
      end

    end

  end
end
