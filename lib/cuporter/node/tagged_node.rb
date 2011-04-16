# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Node
    module TaggedHtml
      def tags
        @tags ||= at(".cuke_name")[:alt].to_s.split(',') || []
      end
    end

    module TaggedXml
      def tags
        @tags ||= attributes["tags"].to_s.split(',') || []
      end
    end
    # a node with a list of tags that can be applied to all children
    module Tagged

      attr_accessor :filter

      def has_tags?
        tags.size > 0
      end
      
      def filter_child(node)
        add_child(node) if @filter.pass?(tags | node.tags)
      end

    end

  end
end
