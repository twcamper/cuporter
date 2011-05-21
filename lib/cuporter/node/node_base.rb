# Copyright 2011 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Node

    module BaseMethods
      include Sorting
      include Totalling
      include Numbering

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

      def find(node)
        children.find {|c| c.eql? node}
      end
      alias :has_child? :find

      def add_leaf(node, *path)
        file_node = Node.new_node("file", document, "fs_name" => path.pop)
        file_node << node
        parent = node_at(*path)
        parent.add_child(file_node) 
      end
      alias :add_to_end :add_leaf

      # *path is a list of nodes forming a path to the last one.
      def node_at(*path)
        return self if path.empty?

        # recursive loop ends when last path_node is shifted off the array
        attributes = {'fs_name' => path.shift}

        # create and add the child node if it's not found among the immediate
        # children of self
        child = children.find do |c|
          c.node_name == 'dir' && c.fs_name == attributes['fs_name']
        end
        unless child
          child = Node.new_node('dir', document, attributes)
          add_child(child)
        end

        child.node_at(*path)
      end

      def short_cuke_name
        @short_cuke_name ||= (cn = cuke_name) ? cn.split(/:\s*/).last : ""
      end

      # value equivalence
      def eql?(other)
        node_name == other.node_name && cuke_name == other.cuke_name && children.eql?(other.children)
      end

      def to_text
        s = Cuporter::Formatters::Text.build_line(self)
        s += children.map {|n| n.to_text}.join
        s
      end
      alias :to_pretty :to_text

      def to_csv
        s = Cuporter::Formatters::Csv.build_line(self)
        s += children.map {|n| n.to_csv}.join
        s
      end

    end

    # common methods for building either html or xml nodes
    module InitializeNode

      def format_name(name)
        node_name = name.to_s.gsub(/([a-z])([A-Z])/,'\1_\2').downcase
        class_name = name.to_s.to_class_name.to_sym
        return node_name, class_name
      end

      def copy_attrs(node, attributes)
        attributes.each do |attr, value|
          next if attr.to_s.downcase == 'type'
          value = value.is_a?(Array) ?  value.join(", ") : value.to_s.strip
          node[attr.to_s] = value unless value.empty?
        end
        node
      end

      def new_node(name, doc, attributes = {})
        node_name, class_name = format_name(name)
        n = Cuporter::Node::Types.const_get(class_name).new(node_name, doc)
        copy_attrs(n, attributes)
      end
    end

  end
end

Cuporter::Node.send(:extend, Cuporter::Node::InitializeNode)
