# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
require 'rubygems'
require 'nokogiri'
Nokogiri::XML::Node.class_eval do
  # undefine the spaceship (comparison operator used by sort)
  # so our mixed-in versions get used.
  remove_method :<=>
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
  attr_accessor :format
  def write
    send("to_#{format}".to_sym, :indent => 2, :encoding => 'UTF-8')
  end
end
Nokogiri::XML::Document.send(:include, DocumentExtensions)
