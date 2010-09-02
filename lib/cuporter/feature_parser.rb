# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License

module Cuporter
  class FeatureParser
    FEATURE_LINE          = /^\s*(Feature:[^#]+)/
    TAG_LINE              = /^\s*(@\w.+)/
    SCENARIO_LINE         = /^\s*(Scenario:[^#]+)$/
    SCENARIO_OUTLINE_LINE = /^\s*(Scenario Outline:[^#]+)$/
    SCENARIOS_LINE        = /^\s*(Scenarios:[^#]*)$/
    EXAMPLES_LINE         = /^\s*(Examples:[^#]*)$/

    def initialize
      @current_tags = []
    end

    def self.parse(feature_content)
      self.new.parse(feature_content)
    end

    def parse(feature_content)
      lines = feature_content.split(/\n/)

      lines.each do |line|
        case line
        when TAG_LINE
          # may be more than one tag line
          @current_tags |= $1.strip.split(/\s+/)
        when FEATURE_LINE
          @feature = TagListNode.new($1.strip, @current_tags)
          @current_tags = []
        when SCENARIO_LINE
          # How do we know when we have read all the lines from a "Scenario Outline:"?
          # One way is when we encounter a "Scenario:"
          if @scenario_outline
            @feature.merge(@scenario_outline)
            @scenario_outline = nil
          end

          @feature.add_to_tag_node(Node.new($1.strip), @current_tags)
          @current_tags = []
        when SCENARIO_OUTLINE_LINE
          # ... another is when we hit a subsequent "Scenario Outline:"
          if @scenario_outline
            @feature.merge(@scenario_outline)
            @scenario_outline = nil
          end

          @scenario_outline  = TagListNode.new($1.strip, @current_tags)
          @current_tags = []
        when EXAMPLES_LINE, SCENARIOS_LINE
          @scenario_outline.add_to_tag_node(Node.new($1.strip), @feature.universal_tags | @current_tags)
          @current_tags = []
        end
      end

      # EOF is the final way that we know we are finished with a "Scenario Outline"
      @feature.merge(@scenario_outline) if @scenario_outline
      return @feature
    end

  end

end
