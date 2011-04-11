# Copyright 2011 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Node
    module Html
      module Parent

        def add_child(node)
          li = Cuporter::Node::NodeBase.new('li', document)
          li << node
          super(li)
        end
      end

      module Leaf
      end
      class Report < NodeBase
        HTML_TAG = :ul
        include Parent
      end
      class Dir < NodeBase
        HTML_TAG = :ul
        include Parent
      end
      class Tag < NodeBase
        HTML_TAG = :ul
        include Parent
      end
      class ScenarioOutline < Tagged
        HTML_TAG = :ul
        include Parent
      end

      class Feature < Tagged
        HTML_TAG = :ul
        include Parent

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

      end

      # The set of examples in a scenario outline
      class Examples < Tagged
        HTML_TAG = :ul

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
        HTML_TAG = :div
        include Leaf
      end

      class Example < NodeBase
        HTML_TAG = :div
        include Leaf
      end
    end
  end
end
