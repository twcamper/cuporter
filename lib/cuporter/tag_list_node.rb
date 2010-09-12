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

    # Have my children adopt the other node's grandchildren.
    #
    # Copy children of other node's top-level, direct descendants to this 
    # node's direct descendants of the same name.
    def merge(other)
      other.children.each do |other_child|
        direct_child               = find_or_create_child(other_child.name)
        new_grandchild             = Node.new(other.name)
        new_grandchild.children    = other_child.children
        new_grandchild.file        = other.file

        direct_child.add_child(new_grandchild)
      end
    end

  end
end
