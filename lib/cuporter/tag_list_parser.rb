# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License

module Cuporter
  class TagListParser < FeatureParser

    # ++sub_expression++ is the paren group in the regex, dereferenced with $1 in the caller
    def new_feature_node(sub_expression)
      TagListNode.new(sub_expression, @current_tags)
    end

    def handle_scenario_line(sub_expression)
      @feature.add_to_tag_nodes(TagListNode.new(sub_expression, @current_tags))
    end

    def new_scenario_outline_node(sub_expression)
      TagListNode.new(sub_expression, @current_tags)
    end

    def handle_example_set_line
      @scenario_outline.add_to_tag_nodes(@example_set)
    end

    def new_example_set_node(sub_expression)
      ExampleSetNode.new(sub_expression, @feature.tags | @current_tags)
    end

    def close_scenario_outline
      if @scenario_outline
        if @example_set
          @scenario_outline.add_to_tag_nodes(@example_set) if @example_set
          @example_set = nil
        end
        @feature.merge_tag_nodes(@scenario_outline)
        @scenario_outline = nil
      end
    end

  end
end
