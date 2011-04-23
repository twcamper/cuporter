# Copyright 2011 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Node

    module ToText
      def depth
        d = path.sub(/^.*\/report/, 'report').split('/').size - 2
        d < 0 ? 0 : d
      end

      def to_text(options = {})
        indent = '  ' * depth
        s = ""
        s = text_line(indent) if self['cuke_name']
        s += children.map {|n| n.to_text}.to_s
        s
      end
      alias :to_pretty :to_text

      def text_line(indent)
        l = indent
        l += self['cuke_name']
        l += "\t[#{self['total']}]" if self['total']
        l += "\t#{self['tags']}" if self['tags']
        l += "\t#{self['file']}" if self['file']
        l += "\n"
        l
      end

    end

  end
end
