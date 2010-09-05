module Cuporter
  class NodeNumberer
    
    attr_reader :total

    def initialize
      @total = 0
    end

    def number(node)
      node.children.each do |child|
        child.number = @total += 1 if child.numerable?
        number(child)
      end
    end

  end
end
