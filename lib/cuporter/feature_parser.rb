# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License

module Cuporter
  class FeatureParser
    FEATURE_LINE          = /^\s*(Feature:[^#]*)/
    TAG_LINE              = /^\s*(@\w.+)/
    SCENARIO_LINE         = /^\s*(Scenario:[^#]*)$/
    SCENARIO_OUTLINE_LINE = /^\s*(Scenario Outline:[^#]*)$/
    SCENARIO_SET_LINE     = /^\s*(Scenarios:[^#]*)$/
    EXAMPLE_SET_LINE      = /^\s*(Examples:[^#]*)$/
    EXAMPLE_LINE          = /^\s*(\|.*\|)\s*$/

    def self.tag_list(file)
      TagListParser.new(file).parse_feature
    end

    def self.name_list(file, filter)
      NameListParser.new(file, filter).parse_feature
    end
  
    def self.node(file, doc, filter)
      NodeParser.new(file, doc, filter).parse_feature
    end
    attr_writer :root

    def initialize(file, root = "features")
      @file = file
      @current_tags = []
      @lines = File.read(@file).split(/\n/)
      @root = root
    end

    def parse_feature
      @lines.each do |line|
        case line
        when FeatureParser::TAG_LINE
          # may be more than one tag line
          @current_tags |= $1.strip.split(/\s+/)
        when FeatureParser::FEATURE_LINE
          @feature = new_feature_node($1, @file.sub(/^.*#{@root}\//,"#{@root}/"))
          @current_tags = []
        when FeatureParser::SCENARIO_LINE
          # How do we know when we have read all the lines from a "Scenario Outline:"?
          # One way is when we encounter a "Scenario:"
          close_scenario_outline

          handle_scenario_line($1)
          @current_tags = []
        when FeatureParser::SCENARIO_OUTLINE_LINE
          # ... another is when we hit a subsequent "Scenario Outline:"
          close_scenario_outline

          @scenario_outline  = new_scenario_outline_node($1)
          @current_tags = []
        when FeatureParser::EXAMPLE_SET_LINE, FeatureParser::SCENARIO_SET_LINE
          handle_example_set_line if @example_set

          begin
          @example_set = new_example_set_node($1)
          rescue NoMethodError
            p @file
            p line
            raise
          end
          @current_tags = []
        when @example_set && FeatureParser::EXAMPLE_LINE
          new_example_line($1)
        end
      end

      # EOF is the final way that we know we are finished with a "Scenario Outline"
      close_scenario_outline
      return @feature
    end

    def new_example_line(sub_expression)
      @example_set.add_child(Node.new(sub_expression))
    end

  end
end
