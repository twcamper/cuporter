# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Node
    module Xml
      class Report < NodeBase
        def tag_node(tag)
          at("tag[cuke_name='#{tag}']")
        end
      end
      class Dir < NodeBase
      end
      class Tag < NodeBase
        def feature_node(feature)
          at("feature[cuke_name='#{feature[:cuke_name]}'][file='#{feature[:file]}']")
        end
      end
      class ScenarioOutline < NodeBase
        include Tagged
        include TaggedXml

        def example_set_node(es)
          at("examples[cuke_name='#{es[:cuke_name]}']")
        end

      end

      class Feature < NodeBase
        include Tagged
        include TaggedXml

        def scenario_outline_node(scenario_outline)
          at("scenario_outline[cuke_name='#{scenario_outline[:cuke_name]}']")
        end

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
      class Examples < NodeBase
        include Tagged
        include TaggedXml

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
      class Scenario < NodeBase
        include Tagged
        include TaggedXml
      end

      class Example < NodeBase
      end
    end
  end
end
