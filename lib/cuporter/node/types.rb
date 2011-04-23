# Copyright 2011 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Node
    module Types
      class Report < NodeBase
        def tag_node(tag)
          at("tag[cuke_name='#{tag}']")
        end

        # remove leaf nodes, i.e., the scenario and scenario outline children
        def defoliate!
          leaves = search("feature > scenario, feature > scenario_outline")
          leaves.remove
        end

        def remove_files!
          search(:feature).each {|f| f.delete('file') }
        end

        def remove_tags!
          search("*[@tags]").each {|e| e.delete('tags') }
        end
      end

      class FilterSummary < NodeBase
        def add(filter)
          self << filter_node(:all, filter.all.join(' AND ')) unless filter.all.empty?
          self << filter_node(:any, filter.any.join(' OR ')) unless filter.any.empty?
          self << filter_node(:none, filter.none.join(', ')) unless filter.none.empty?
        end

        def filter_node(name, text)
          fn = NodeBase.new(name.to_s, document)
          fn['tags'] = text
          fn
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

        def example_set_node(es)
          at("examples[cuke_name='#{es[:cuke_name]}']")
        end

      end

      class Feature < NodeBase
        include Tagged

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

        # don't sort scenario outline examples
        def sort!
          # no op
        end

        # don't total at the example set level
        def total
          # no op
        end

        def add_child(other)
          cn = other['cuke_name'].dup
          cn.sub!(/^\|/, '')
          cn.split('|').each do |cell_text|
            cell = Nokogiri::XML::Node.new("span", document)
            cell.content = cell_text.strip
            other << cell
          end
          super(other)
        end
      end
      Scenarios = Examples

      # Leaf Nodes: won't have children
      class Scenario < NodeBase
        include Tagged

        def text_line(indent)
          l = indent
          l += "#{self['number']}. " if self['number']
          l += self['cuke_name']
          l += "\t#{self['tags']}" if self['tags']
          l += "\n"
          l
        end
      end

      class Example < NodeBase
        def text_line(indent)
          l = indent
          l += "#{self['number']}. " if self['number']
          l += self['cuke_name']
          l += "\n"
          l
        end
      end
      class ExampleHeader < NodeBase
      end
    end
  end
end
