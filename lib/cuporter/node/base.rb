# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Node

    module BaseMethods
      include Comparable

      def has_children?
        children.size > 0
      end

      def names
        children.collect {|c| c.content }
      end

      def find_by_name(name)
        children.find {|c| c.content == name.to_s}
      end

      def find_by_type(type, name)
        children.find {|c| c.type == type && c.content == name.to_s}
      end

      def find(node)
        children.find {|c| c.eql? node}
      end
      alias :has_child? :find

      def add_leaf(path, node)
        node_at(path).add_child(node)
      end
      alias :add_to_end :add_leaf

      def node_at(path)
        return self if path.empty?

        type, name = path.shift
        unless (child = find_by_type(type, name))
          child = Node.const_get(type).new(name)
          add_child(child)
        end
        child.node_at(path)
      end

      def name_without_title
        @name_without_title ||= name.split(/:\s+/).last
      end

      def sort_all_descendants!
        sort!
        children.each {|child| child.sort_all_descendants! }
      end

      def sort!
        children.sort!
      end

      # sort on: substring of name after any ':'
      def <=>(other)
        name_without_title <=> other.name_without_title
      end

      # value equivalence
      def eql?(other)
        name == other.name && content == other.content && children == other.children
      end

      def total
        t = search("*[@number]").size
        self["total"] = t.to_s if t > 0
        children.each {|child| child.total }
      end

      def number_all_descendants
        @numberer = Numberer.new
        @numberer.number(self)
      end

      def to_s
        self["name"]
      end
    end

    def self.new_node(name, doc, attributes = {})
      n = Cuporter::Node.const_get(name).new(name.to_s, doc)
      attributes.each do | attr, value |
        value = value.is_a?( Array) ?  value.join(",") : value.to_s
        n[attr.to_s] = value unless value.empty?
      end
      n
    end

  end
end

Nokogiri::XML::Node.send(:include, Cuporter::Node::BaseMethods)
