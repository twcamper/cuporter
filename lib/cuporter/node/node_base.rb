# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module InitializeNode

    def format_name(name)
      node_name = name.to_s.gsub(/([a-z])([A-Z])/,'\1_\2').downcase
      class_name = name.to_s.to_class_name.to_sym
      return node_name, class_name
    end

    def copy_attrs(node, attributes)
      attributes.each do | attr, value |
        value = value.is_a?(Array) ?  value.join(",") : value.to_s.strip
        node[attr.to_s] = value unless value.empty?
      end
      node
    end
  end

  module XMLNode
    include InitializeNode

    def new_node(name, doc, attributes = {})
      node_name, class_name = format_name(name)
      n = Cuporter::Node::Xml.const_get(class_name).new(node_name, doc)
      copy_attrs(n, attributes)
    end
  end
  module HTMLNode
    include InitializeNode

    def new_node(name, doc, attributes = {})
      node_name, class_name = format_name(name)
      node_class = Cuporter::Node::Html.const_get(class_name)
      n = node_class.new(node_class::HTML_TAG.to_s, doc)
      n = copy_attrs(n, attributes.merge(:class => node_name))
      n.build
      n
    end
  end
  module Node
    extend Cuporter.const_get("#{Cuporter::CLI::Options[:format] == :html ? 'HTML' : 'XML'}Node".to_sym)

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

      def find_by(node_name, attributes)
        children.find do |c|
          c.node_name == node_name && c.cuke_name == attributes['cuke_name']  && c['file'] == attributes['file']
        end
      end

      def find(node)
        children.find {|c| c.eql? node}
      end
      alias :has_child? :find

      def add_leaf(node, *path)
        parent = node_at(*path)
        parent.add_child(node.dup(1)) unless parent.has_child? node
      end
      alias :add_to_end :add_leaf

      # *path is a list of nodes forming a path to the last one.
      # a 'node' here is either a Node object or a node_name/cuke_name pair
      def node_at(*path)
        return self if path.empty?

        # recursive loop ends when last path_node is shifted off the array
        path_node = path.shift

        if path_node.is_a? Array
          type = path_node[0].to_s.downcase
          attributes = {'cuke_name' => path_node[1]}
        else
          type = path_node.node_name
          attributes = {'cuke_name' => path_node.cuke_name}
          path_node.attribute_nodes.each do |attr|
            attributes[attr.name] = attr.value
          end
        end

        # create and add the child node if it's not found among the immediate
        # children of self
        unless( child = find_by(type, attributes) )
          child = Node.new_node(type, document, attributes)
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

      def build; end
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

    NodeBase = Nokogiri::XML::Node
  end
end


Cuporter::Node::NodeBase.send(:include, Cuporter::Node::BaseMethods)
