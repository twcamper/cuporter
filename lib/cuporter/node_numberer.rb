module Cuporter
  class NodeNumberer
    
    attr_reader :total

    def initialize
      @total = 0
    end

    def number(node)
      number_children(node)
      node.children.each {|child| number(child) }
    end

    private
    def number_children(node)
      node.children.each do |c|
        c.number = @total += 1 unless c.has_children?
      end
    end
  end
end
