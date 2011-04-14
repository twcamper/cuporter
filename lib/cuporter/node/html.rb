# Copyright 2011 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Node
    module Html

      class Parent < NodeBase

        def build
          super(node_name)
          self << ul
        end

        def ul
          @ul ||= NodeBase.new('ul', document)
        end

        def add_child(node)
          if node['class'] == 'cuke_name'
            super(node)
          else
            ul << node
          end
        end
      end

      module Leaf
      end
      class Report < Parent
        HTML_TAG = :div
      end
      class Dir < Parent
        HTML_TAG = :div
      end
      class Tag < Parent
        HTML_TAG = :div
      end
      class ScenarioOutline < Parent
        include Tagged
        HTML_TAG = :li
      end

      class Feature < Parent
        include Tagged
        HTML_TAG = :li

        def file
          self["file"]
        end

        def file_name
          path = delete('file').value.split(File::SEPARATOR)
          name = html_node(:span)
          name.content = "/#{path.pop}"
          parent = html_node(:em)
          parent.content = "/#{path.pop}"
          div = html_node('div', :class => 'file')
          div.children = path.join('/')
          div << parent
          div << name
          div
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
          super do
            self << file_name
            self << ul
          end
        end

      end

      # The set of examples in a scenario outline
      class Examples < NodeBase
        include Tagged
        HTML_TAG = :li

        def build
          super('div') do
            table << thead
            table << tbody
            self << table
          end
        end

        def table
          @table ||= NodeBase.new('table', document)
        end

        def thead
          @thead ||= NodeBase.new('thead', document)
        end

        def tbody
          @tbody ||= NodeBase.new('tbody', document)
        end

        # don't sort scenario outline examples
        def sort!
          # no op
        end

        def has_children?
          at('.example')
        end

        def add_child(other)
          if other.is_a? Example
            if has_children? # not the first row ( arg list header)
              tbody << other
            else
              thead << header_row(other)
            end
          else
            self << other
          end
        end

        def header_row(other)
          other.delete("number")
          other.children.each { |td| td.node_name = "th" }
          other
        end
      end
      Scenarios = Examples

      # Leaf Nodes: won't have children
      class Scenario < NodeBase
        HTML_TAG = :li
        include Leaf
        include Tagged

      end

      class Example < NodeBase
        HTML_TAG = :tr
        
        def build
          row = delete('cuke_name').value.split('|').reject { |s| s.empty? }
          row.each do | cell_text |
            td = NodeBase.new('td', document)
            td.content = cell_text.strip
            add_child(td)
          end
        end
      end
    end
  end
end
