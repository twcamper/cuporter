# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Node
    # a node with a list of tags that can be applied to all children
    class Tagged < BaseNode

      attr_accessor :filter

      def has_tags?
        tags.size > 0
      end
      
      def tags
        @tags ||= attributes["tags"].to_s.split(',') || []
      end

      def filter_child(node)
        add_child(node) if @filter.pass?(tags | node.tags)
      end

      def find_or_create_child(name)
        child_node = self[name]
        unless child_node


          # what do we do here??
          children << Node.new(name)
          
          
          child_node = children.last
        end
        child_node
      end

    end
  end
end
