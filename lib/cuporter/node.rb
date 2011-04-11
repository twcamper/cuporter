# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
require 'lib/cuporter/node/node_base'
require 'lib/cuporter/node/tagged_node'
Dir["lib/cuporter/node/*.rb"].each do |lib|
  require lib
end

module Cuporter
  module Node
    class Report < NodeBase
      def self.html_tag; end
    end
    class Dir < NodeBase
      def self.html_tag; end
    end
    class Tag < NodeBase
      def self.html_tag; end
    end
    class ScenarioOutline < Tagged
      def self.html_tag; end
    end

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
      def build
        add_child parse("<div class='cuke_name'>#{delete('cuke_name').value}</div>")
      end

      def self.html_tag
        'li'
      end
    end

    # The set of examples in a scenario outline
    class Examples < Tagged
      def self.html_tag; end

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
      def self.html_tag; end
    end

    class Example < NodeBase
      def self.html_tag; end
    end
  end
end
