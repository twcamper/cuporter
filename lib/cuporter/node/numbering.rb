# Copyright 2011 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Node
    module Numbering
      class Numberer

        attr_reader :total

        def initialize
          @total = 0
        end

        def number(node)
          node.children.each do |child|
            case child.node_name
            when 'scenario', 'example'
              child["number"] = (@total += 1).to_s
            end
            number(child)
          end
        end

      end

      def number_all_descendants
        @numberer = Numberer.new
        @numberer.number(self)
      end

    end
  end
end
