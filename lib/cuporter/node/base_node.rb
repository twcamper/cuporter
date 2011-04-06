# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Node

    module BaseMethods
      include Comparable

      def has_children?
        children.size > 0
      end

      def names
        children.collect {|c| c.name }
      end

      def find_by_name(name)
        children.find {|c| c.name == name.to_s}
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
        return unless has_children?
        kidz = children.sort
        self.children = kidz
      end
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

      def depth_to(root)
        d = path.sub(/^.*\/#{root}/, root).split('/').size - 1
        d < 0 ? 0 : d
      end

      def to_text(options = {})
        indent = '  ' * depth_to("feature")
        s = ""
        s = "#{indent}#{self['name']}\n" if self['name']
        s += children.map {|n| n.to_text}.to_s
        s
      end
      alias :to_pretty :to_text

    end

    def self.new_node(name, doc, attributes = {})
      node_name = name.to_s.gsub(/([a-z])([A-Z])/,'\1_\2').downcase
      n = Cuporter::Node.const_get(name).new(node_name, doc)
      attributes.each do | attr, value |
        value = value.is_a?( Array) ?  value.join(",") : value.to_s
        n[attr.to_s] = value unless value.empty?
      end
      n
    end
  
    BaseNode = Nokogiri::XML::Node
  end
end


module NodeSetSort
  def sort
    return self if empty?
    sorted = to_a.sort
    self.class.new(document, sorted)
  end
end

Nokogiri::XML::NodeSet.send(:include, NodeSetSort)
Cuporter::Node::BaseNode.class_eval do
  remove_method :<=>
end

Cuporter::Node::BaseNode.send(:include, Cuporter::Node::BaseMethods)
