# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License

module Cuporter
  class NodeParser < FeatureParser

    # ++sub_expression++ is the paren group in the regex, dereferenced with $1 in the caller
    def new_feature_node(sub_expression, file)
      f = Node.new_node(:Feature, @doc, :value => sub_expression, :tags => @current_tags, :file => file)
      f.filter = @filter
      f
    end

    def handle_scenario_line(sub_expression)
      @feature.filter_child(Node.new_node(:Scenario, @doc, :value => sub_expression, :tags => @current_tags, :number => true))
    end

    def new_scenario_outline_node(sub_expression)
      so = Node.new_node(:ScenarioOutline, @doc, :value => sub_expression, :tags => @current_tags)
      so.filter = @filter
      so
    end

    def handle_example_set_line
      @scenario_outline.filter_child(@example_set)
    end

    def new_example_set_node(sub_expression)
      es = Node.new_node(:Examples, @doc, :value => sub_expression, :tags => (@feature.tags | @current_tags))
      es.filter = @filter
      es
    end

    def new_example_line(sub_expression)
      @example_set.add_child(Node.new_node(:Example, @doc, :value => sub_expression, :number => true))
    end

    def close_scenario_outline
      if @scenario_outline
        if @example_set
          @scenario_outline.filter_child(@example_set) if @example_set
          @example_set = nil
        end
        @feature.add_child(@scenario_outline) if @scenario_outline.has_children?
        @scenario_outline = nil
      end
    end

    def initialize(file, doc, filter)
      super(file)
      @filter = filter
      @doc = doc
    end

  end
end
