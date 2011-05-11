# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
Nokogiri::XML::Node.class_eval do
  # undefine the spaceship (comparison operator used by sort)
  # so our mixed-in versions get used.
  remove_method :<=>
  include(Cuporter::Node::BaseMethods)

  # Nokogiri 1.4.1 backwards compatability
  unless instance_methods.include?("children=")

    # defined in 1.4.4
    def children=(node_or_tags)
      children.unlink
      if node_or_tags.is_a?(Nokogiri::XML::NodeSet)
        node_or_tags.each { |n| add_child_node n }
      else
        add_child_node node_or_tags 
      end
      node_or_tags
    end

  end
end

module NodeSetExtensions
  def sort
    return self if empty?
    sorted = to_a.sort
    self.class.new(document, sorted)
  end

  # value equivalence
  def eql?(other)
    return false unless other.is_a?(Nokogiri::XML::NodeSet)
    return false unless length == other.length
    each_with_index do |node, i|
      return false unless node.eql?(other[i])
    end
    true
  end
end
Nokogiri::XML::NodeSet.send(:include, NodeSetExtensions)

module DocumentExtensions

  def add_report(report_node)
    root.at(:body) << report_node
  end

  def add_filter_summary(filter)
    return if filter.empty?
    s = Cuporter::Node.new_node(:FilterSummary, self)
    s.add(filter)
    root.at(:body) << s
  end
end
Nokogiri::XML::Document.class_eval do

  # Nokogiri 1.4.1 backwards compatability
  unless instance_methods.include?("create_cdata")
    # defined in 1.4.4
    def create_cdata(text)
      Nokogiri::XML::CDATA.new(self, text.to_s)
    end
  end

  include(DocumentExtensions)
end
