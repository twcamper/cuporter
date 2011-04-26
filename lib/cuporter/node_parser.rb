# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License

module Cuporter
  class NodeParser < FeatureParser

    # ++sub_expression++ is the paren group in the regex, dereferenced with $1 in the caller
    def new_feature_node(sub_expression, file)
      f = Node.new_node(:Feature, @doc, :cuke_name => sub_expression, :tags => @current_tags, :file_path => file)
      f.filter = @filter
      f
    end

    def handle_scenario_line(sub_expression)
      if @filter.pass?(@current_tags | @feature.tags)
        @feature.add_child(Node.new_node(:Scenario, @doc, :cuke_name => sub_expression, :tags => @current_tags))
      end
    end

    def new_scenario_outline_node(sub_expression)
      so = Node.new_node(:ScenarioOutline, @doc, :cuke_name => sub_expression, :tags => @current_tags)
      so.filter = @filter
      so
    end

    def handle_example_set_line
      if @filter.pass?(@feature.tags | @scenario_outline.tags | @example_set.tags)
        @scenario_outline.add_child @example_set
      end
    end

    def new_example_set_node(sub_expression)
      es = Node.new_node(:Examples, @doc, :cuke_name => sub_expression, :tags => @current_tags)
      es.filter = @filter
      es
    end

    def new_example_line(sub_expression)
      example_type = :ExampleHeader
      # if the example set has a child already, then it must be the header
      example_type = :Example if @example_set.has_children?
      @example_set.add_child(Node.new_node(example_type, @doc, :cuke_name => sub_expression))
    end

    def close_scenario_outline
      if @scenario_outline
        if @example_set
          handle_example_set_line
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
