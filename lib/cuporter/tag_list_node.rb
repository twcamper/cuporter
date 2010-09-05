# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  # a node with a list of tags that can be applied to all children
  class TagListNode < Node

    attr_reader :tags

    def initialize(name, tags)
      super(name)
      @tags = tags
    end

    def has_tags?
      @tags.size > 0
    end

    def add_to_tag_nodes(node)
      (tags | node.tags).each do |tag|
        tag_node = find_or_create_child(tag)
        tag_node.add_child(node)
      end
    end

  end
end
