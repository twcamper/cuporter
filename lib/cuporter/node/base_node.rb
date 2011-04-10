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

      def cuke_names
        children.collect {|c| c.cuke_name }
      end

      def cuke_name
        @cuke_name ||= self['cuke_name'].to_s
      end

      def find_by_name(name)
        children.find {|c| c.name == name.to_s}
      end

      def find_by_type(node_name, cuke_name)
        children.find do |c|
          c.node_name == node_name.to_s.downcase && c.cuke_name == cuke_name
        end
      end

      def find_by_attributes(node)
        children.find do |c|
          c.node_name == node.node_name && c.cuke_name == node.cuke_name  && c['file'] == node['file']
        end
      end

      def find(node)
        children.find {|c| c.eql? node}
      end
      alias :has_child? :find

      def add_leaf(node, *path)
        parent = node_at(*path)
        parent.add_child(node) unless parent.has_child? node
      end
      alias :add_to_end :add_leaf

      # *path is a list of nodes forming a path to the last one.
      # a 'node' here is either a Node object or type, cuke_name pair
      def node_at(*path)
        return self if path.empty?

        path_node = path.shift
=begin
        if path_node.is_a? Array
          type, cuke_name = path_node
          attributes = {:cuke_name => cuke_name}
          #
          #path_node = Node.new_node(type, document, :cuke_name => cuke_name)
#       else
#         path_node = path.shift
        else
          type = path_node.node_name
          cuke_name = path_node.cuke_name
          attributes = path_node.attributes
        end
        unless( child = find_by_type(type, cuke_name) )
          child = Node.new_node(type, document, attributes)
          add_child(child)
=end
        unless( child = find_by_attributes(path_node) )
          child = Node.new_node(path_node.node_name, document, path_node.attributes)
          add_child(child)
        end
        child.node_at(*path)
      end

      def short_cuke_name
        @short_cuke_name ||= cuke_name.split(/:\s*/).last
      end

      def sort_all_descendants!
        sort!
        children.each {|child| child.sort_all_descendants! }
      end

      def sort!
        return unless has_children?
        sorted_children = children.sort
        self.children = sorted_children
      end

      def <=>(other)
        (short_cuke_name || name) <=> (other.short_cuke_name || other.name)
      end

      # value equivalence
      def eql?(other)
        node_name == other.node_name && cuke_name == other.cuke_name && children.eql?(other.children)
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
        s = "#{indent}#{self['cuke_name']}\n" if self['cuke_name']
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
        value = value.is_a?( Array) ?  value.join(",") : value.to_s.strip

        n[attr.to_s] = value unless value.empty?
      end
      n
    end
  
    BaseNode = Nokogiri::XML::Node
  end
end


Cuporter::Node::BaseNode.send(:include, Cuporter::Node::BaseMethods)