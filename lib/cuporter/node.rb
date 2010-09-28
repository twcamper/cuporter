# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  class Node
    include Comparable

    attr_reader :name
    attr_accessor :children, :number, :file


    def initialize(name)
      @name = name.to_s.strip
      @children = []
    end

    def has_children?
      @children.size > 0
    end

    # will not add duplicate
    def add_child(node)
      @children << node unless has_child?(node)
    end

    def names
      children.collect {|c| c.name }
    end

    def find_by_name(name)
      children.find {|c| c.name == name.to_s}
    end
    alias :[] :find_by_name

    def find(node)
      children.find {|c| c == node}
    end
    alias :has_child? :find
    
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

    # sort on name or substring of name after any ':'
    def <=>(other)
      name_without_title <=> other.name_without_title
    end
    
    # value equivalence
    def eql?(other)
      name == other.name && children == other.children
    end
    alias :== :eql?


    def total
      number_all_descendants unless @numberer
      @numberer.total
    end

    def number_all_descendants
      @numberer = NodeNumberer.new
      @numberer.number(self)
    end

    def numerable?
      @numerable.nil? ? !has_children? : @numerable
    end
    attr_writer :numerable

  end
end
