# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License

module Cuporter
  class TagNodesParser < FeatureParser

    # ++sub_expression++ is the paren group in the regex, dereferenced with $1 in the caller
    def new_feature_node(sub_expression, file)
      f = Node.new_node(:Feature, @doc, :cuke_name => sub_expression, :tags => @current_tags, :file => file)
      f.filter = @filter
      f
    end

    def handle_scenario_line(sub_expression)
      s = @feature.filter_child(Node.new_node(:Scenario, @doc, :cuke_name => sub_expression, :tags => @current_tags, :number => true))

      if s
        (@current_tags | @feature.tags).each do |tag|
          next unless @filter.pass? tag.to_a
          @report.add_leaf(s, [:tag, tag], @feature)
        end
      end
    end

    def new_scenario_outline_node(sub_expression)
      so = Node.new_node(:ScenarioOutline, @doc, :cuke_name => sub_expression, :tags => @current_tags)
      so.filter = @filter
      so
    end

    def handle_example_set_line
      @scenario_outline.filter_child(@example_set)
    end

    def new_example_set_node(sub_expression)
      es = Node.new_node(:Examples, @doc, :cuke_name => sub_expression, :tags => (@feature.tags | @current_tags))
      es.filter = @filter
      es
    end

    def new_example_line(sub_expression)
      e = Node.new_node(:Example, @doc, :cuke_name => sub_expression, :number => true)
      (@current_tags | @example_set.tags | @scenario_outline.tags | @feature.tags).each do |tag|
        next unless @filter.pass? tag.to_a
        @report.add_leaf(e, [:tag, tag], @feature, @scenario_outline, @example_set)
      end
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

    def initialize(file, report, filter)
      super(file)
      @filter = filter
      @report = report
      @doc    = report.document
    end

  end
end
