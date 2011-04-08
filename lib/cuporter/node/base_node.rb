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

      def value
        @value ||= self['value'].to_s
      end

      def find_by_value(value)
        children.find {|c| c.value == value }
      end

      def find_by_name(name)
        children.find {|c| c.name == name.to_s}
      end

      def find_by_type(node_name, value)
        children.find {|c| c.node_name == node_name.to_s.downcase && c.value == value.to_s}
      end

      def find(node)
        children.find {|c| c.eql? node}
      end
      alias :has_child? :find

      def add(type, attributes)
        unless (child = find_by_value(attributes[:value]))
          child = Node.new_node(type, document, attributes)
          add_child(child)
        end
        child
      end

      def add_leaf(node, *path)
        parent = node_at(*path)
        parent.add_child(node) unless parent.has_child? node
      end
      alias :add_to_end :add_leaf

      # *path is a list of nodes forming a path to the last one.
      # a 'node' here is either a Node object or type, value pair
      def node_at(*path)
        return self if path.empty?

        path_node = path.shift
        if path_node.is_a? Array
          type, value = path_node
          child = find_by_type(type, value)
          unless child
            child = Node.new_node(type, document, :value => value)
            add_child(child)
          end
        else
          unless( child = at("#{path_node.node_name}[@value='#{path_node.value}']") )
            add_child(path_node.dup)
            child = children.last
          end
        end
        child.node_at(*path)
      end

      def value_without_title
        @value_without_title ||= value.split(/:\s*/).last
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
=begin
        p "v #{value_without_title}"
        p "name #{ name}"# <=> (other.value_without_title || other.name)
        p "other v: #{other.value_without_title}"
        p "other name:#{ other.name}"
=end
        (value_without_title || name) <=> (other.value_without_title || other.name)
      end

      # value equivalence
      def eql?(other)
        node_name == other.node_name && value == other.value && children == other.children
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

      def depth
        d = path.sub(/^.*\/report/, 'report').split('/').size - 2
        d < 0 ? 0 : d
      end

      def to_text(options = {})
        indent = '  ' * depth
        s = ""
        s = "#{indent}#{self['value']}\n" if self['value']
        s += children.map {|n| n.to_text}.to_s
        s
      end
      alias :to_pretty :to_text

    end

    def self.new_node(name, doc, attributes = {})
      node_name = name.to_s.gsub(/([a-z])([A-Z])/,'\1_\2').downcase
      class_name = name.to_s.to_class_name.to_sym
      n = Cuporter::Node.const_get(class_name).new(node_name, doc)
      attributes.each do | attr, value |
        value = value.is_a?( Array) ?  value.join(",") : value.to_s

        n[attr.to_s] = value.to_s
      end
      n
    end
  
    BaseNode = Nokogiri::XML::Node
  end
end


Cuporter::Node::BaseNode.send(:include, Cuporter::Node::BaseMethods)
