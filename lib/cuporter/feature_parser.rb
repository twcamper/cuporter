# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License

module Cuporter
  class FeatureParser
    FEATURE_LINE          = /^\s*(Feature:[^#]+)/
    TAG_LINE              = /^\s*(@\w.+)/
    SCENARIO_LINE         = /^\s*(Scenario:[^#]+)$/
    SCENARIO_OUTLINE_LINE = /^\s*(Scenario Outline:[^#]+)$/
    SCENARIO_SET_LINE     = /^\s*(Scenarios:[^#]*)$/
    EXAMPLE_SET_LINE      = /^\s*(Examples:[^#]*)$/
    EXAMPLE_LINE          = /^\s*(\|.*\|)\s*$/

    def initialize(file)
      @file = file
      @current_tags = []
    end

    def self.parse(file)
      self.new(file).parse
    end

    def parse
      lines = File.read(@file).split(/\n/)

      lines.each_with_index do |line, i|
        case line
        when TAG_LINE
          # may be more than one tag line
          @current_tags |= $1.strip.split(/\s+/)
        when FEATURE_LINE
          @feature = TagListNode.new($1, @current_tags)
          @feature.file = @file.sub(/^.*features\//,"features/")
          @current_tags = []
        when SCENARIO_LINE
          # How do we know when we have read all the lines from a "Scenario Outline:"?
          # One way is when we encounter a "Scenario:"
          close_scenario_outline

          @feature.add_to_tag_nodes(TagListNode.new($1, @current_tags))
          @current_tags = []
        when SCENARIO_OUTLINE_LINE
          # ... another is when we hit a subsequent "Scenario Outline:"
          close_scenario_outline

          @scenario_outline  = TagListNode.new($1, @current_tags)
          @current_tags = []
        when EXAMPLE_SET_LINE, SCENARIO_SET_LINE
          @scenario_outline.add_to_tag_nodes(@example_set) if @example_set

          @example_set = ExampleSetNode.new($1, @feature.tags | @current_tags)
          @current_tags = []
        when @example_set && EXAMPLE_LINE
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
        @feature.merge(@scenario_outline)
        @scenario_outline = nil
      end
    end
  end

end
