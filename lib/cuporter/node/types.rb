# Copyright 2011 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Node
    NodeBase = Nokogiri::XML::Node
    module Types

      module FeatureNodeFinder
        def feature_node(feature)
          at("feature[cuke_name='#{feature[:cuke_name]}'][file_path='#{feature[:file_path]}']")
        end
      end

      class Report < NodeBase
        include FeatureNodeFinder

        def tag_node(tag)
          at("tag[cuke_name='#{tag}']")
        end

        # remove leaf nodes, i.e., the scenario and scenario outline children
        def defoliate!
          leaves = search("feature > scenario, feature > scenario_outline")
          leaves.remove
        end

        def remove_files!
          search(:feature).each {|f| f.delete('file_path') }
        end

        def remove_tags!
          search("*[@tags]").each {|e| e.delete('tags') }
        end

        def move_tagless_node_to_bottom
          tagless = at("tag[cuke_name='@TAGLESS']")
          add_child(tagless.remove) if tagless
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

      module FileSystemNode
        def fs_name
          @fs_name ||= self['fs_name']
        end
      end

      class Dir < NodeBase
        include FileSystemNode

        def <=>(other)
          return -1 if other.is_a? File  # ensure folders sort higher
          fs_name <=> (other['fs_name'] || other['cuke_name'])
        end

      end

      class File < NodeBase
        include FileSystemNode

        # just total self, don't let any children total themselves.  This is so
        # the feature won't re-total itself when its containing file already has.
        def total
          total!
        end

        def <=>(other)
          return 1 if other.is_a? Dir # ensure folders sort higher
          fs_name <=> (other['fs_name'] || other['cuke_name'])
        end
      end

      class Tag < NodeBase
        include FeatureNodeFinder
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

        def file_path
          self["file_path"]
        end

        def file_name
          file_path.split(/\//).last
        end

        # sort on: file path, name, substring of name after any ':'
        def <=>(other)
          if other.respond_to?(:file_path)
            file_path <=> other.file_path
          else
            super(other)
          end
        end

        def eql?(other)
          if other.respond_to? :file_path
            return false if file_path != other.file_path
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
      end

      class Example < NodeBase
      end

      class ExampleHeader < NodeBase
      end
    end
  end
end

