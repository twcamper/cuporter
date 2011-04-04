module Cuporter
  module Node
    class Numberer

      attr_reader :total

      def initialize
        @total = 0
      end

      def number(node)
        node.children.each do |child|
          if child["number"] 
            child["number"] = (@total += 1).to_s
          end
          number(child)
        end
      end

    end
  end
end
