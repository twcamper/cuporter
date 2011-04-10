# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
require 'lib/cuporter/node/base_node'
require 'lib/cuporter/node/tagged_node'
Dir["lib/cuporter/node/*.rb"].each do |lib|
  require lib
end

module Cuporter
  module Node
    class Report < BaseNode; end
    class Dir < BaseNode; end
    class Tag < BaseNode; end
    class ScenarioOutline < Tagged; end

    class Feature < Tagged

      def file
        self["file"]
      end

      def file_name
        file.split(/\//).last
      end

      # sort on: file path, name, substring of name after any ':'
      def <=>(other)
        if other.respond_to?(:file)
          file <=> other.file
        else
          super(other)
        end
      end

      def eql?(other)
        if other.respond_to? :file
          return false if file != other.file
        end
        super(other)
      end

    end

    # The set of examples in a scenario outline
    class Examples < Tagged

      # don't sort scenario outline examples
      def sort!
        # no op
      end

      def add_child(other)
        unless has_children? #first row ( arg list header)
          other.delete("number")
        end
        super(other)
      end
    end
    Scenarios = Examples

    # Leaf Nodes: won't have children
    class Scenario < Tagged
    end

    class Example < BaseNode
    end
  end
end
