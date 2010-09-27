# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License

module Cuporter
  class TagList

    def initialize(file)
      @file = file
      @current_tags = []
    end

    def parse_feature
      lines = File.read(@file).split(/\n/)

      lines.each do |line|
        case line
        when FeatureParser::TAG_LINE
          # may be more than one tag line
          @current_tags |= $1.strip.split(/\s+/)
        when FeatureParser::FEATURE_LINE
          @feature = TagListNode.new($1, @current_tags)
          @feature.file = @file.sub(/^.*features\//,"features/")
          @current_tags = []
        when FeatureParser::SCENARIO_LINE
          # How do we know when we have read all the lines from a "Scenario Outline:"?
          # One way is when we encounter a "Scenario:"
          close_scenario_outline

          @feature.add_to_tag_nodes(TagListNode.new($1, @current_tags))
          @current_tags = []
        when FeatureParser::SCENARIO_OUTLINE_LINE
          # ... another is when we hit a subsequent "Scenario Outline:"
          close_scenario_outline

          @scenario_outline  = TagListNode.new($1, @current_tags)
          @current_tags = []
        when FeatureParser::EXAMPLE_SET_LINE, FeatureParser::SCENARIO_SET_LINE
          @scenario_outline.add_to_tag_nodes(@example_set) if @example_set

          @example_set = ExampleSetNode.new($1, @feature.tags | @current_tags)
          @current_tags = []
        when @example_set && FeatureParser::EXAMPLE_LINE
          @example_set.add_child(Node.new($1))
        end
      end

      # EOF is the final way that we know we are finished with a "Scenario Outline"
      close_scenario_outline
      return @feature
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
