# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  # a node with a list of tags that apply to all children
  class TagListNode < Node

    attr_reader :universal_tags

    def initialize(name, universal_tags)
      super(name)
      @universal_tags = universal_tags
    end

    def has_universal_tags?
      @universal_tags.size > 0
    end

    def add_to_tag_node(node, childs_tags = [])
      (universal_tags | childs_tags).each do |tag|
        tag_node = find_or_create_child(tag)
        tag_node.add_child(node)
      end
    end

  end
end
