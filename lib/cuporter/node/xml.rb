# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Node
    module Xml
      class Report < NodeBase
        def add_scenario(tag, feature, scenario)
          if ( f = feature_node(tag, feature))
            f.add_child(Node.new_node(scenario[:type], document, scenario))
          elsif ( t =  tag_node(tag))
            t.add_child(Node.new_node(feature[:type], document, feature)).
              add_child(Node.new_node(scenario[:type], document, scenario))
          else
            add_child(Node.new_node(:tag, document, 'cuke_name' => tag)).
              add_child(Node.new_node(feature[:type], document, feature)).
              add_child(Node.new_node(scenario[:type], document, scenario))
          end
        end

        def add_example(tag, feature, scenario_outline, example_set, example)
          if ( es = example_set_node(tag, feature, scenario_outline, example_set))
            es.add_child(Node.new_node(example[:type], document, example))
          elsif ( so  = scenario_outline_node(tag, feature, scenario_outline))
            so.add_child(Node.new_node(example_set[:type], document, example_set)).
              add_child(Node.new_node(example[:type], document, example))
          elsif ( f = feature_node(tag, feature))
            f.add_child(Node.new_node(scenario_outline[:type], document, scenario_outline)).
              add_child(Node.new_node(example_set[:type], document, example_set)).
              add_child(Node.new_node(example[:type], document, example))
          elsif ( t =  tag_node(tag))
            t.add_child(Node.new_node(feature[:type], document, feature)).
              add_child(Node.new_node(scenario_outline[:type], document, scenario_outline)).
              add_child(Node.new_node(example_set[:type], document, example_set)).
              add_child(Node.new_node(example[:type], document, example))
          else
            add_child(Node.new_node(:tag, document, 'cuke_name' => tag)).
              add_child(Node.new_node(feature[:type], document, feature)).
              add_child(Node.new_node(scenario_outline[:type], document, scenario_outline)).
              add_child(Node.new_node(example_set[:type], document, example_set)).
              add_child(Node.new_node(example[:type], document, example))
          end
        end

        def tag_node(tag)
          at("tag[cuke_name='#{tag}']")
        end

        def feature_node(tag, feature)
          at("tag[cuke_name='#{tag}'] > feature[cuke_name='#{feature[:cuke_name]}'][file='#{feature[:file]}']")
        end

        def scenario_outline_node(tag, feature, scenario_outline)
          at("tag[cuke_name='#{tag}'] > feature[cuke_name='#{feature[:cuke_name]}'][file='#{feature[:file]}'] > scenario_outline[cuke_name='#{scenario_outline[:cuke_name]}']")
        end

        def example_set_node(tag, feature, so, es)
          at("tag[cuke_name='#{tag}'] > feature[cuke_name='#{feature[:cuke_name]}'][file='#{feature[:file]}'] > scenario_outline[cuke_name='#{so[:cuke_name]}'] > examples[cuke_name='#{es[:cuke_name]}']")
        end

      end
      class Dir < NodeBase
      end
      class Tag < NodeBase
      end
      class ScenarioOutline < NodeBase
        include Tagged
        include TaggedXml
      end

      class Feature < NodeBase
        include Tagged
        include TaggedXml

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
