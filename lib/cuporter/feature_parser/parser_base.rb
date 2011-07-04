# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License

module Cuporter
  module FeatureParser
    class ParserBase
      TAG_LINE              = /^\s*(@\w.+)/u
      EXAMPLE_LINE          = /^\s*(\|.*\|)\s*$/u
      PY_STRING_LINE        = /^\s*"""\s*$/u
   
      def initialize(file)
        @file = file
        @current_tags = []
        @lines = File.read(@file).split(/\n/)
        @lang  = Language.new(@lines.first)
      end
      attr_reader :lang
      attr_writer :root

      def file_relative_path
        @file_relative_path ||= @file.sub(/^.*#{@root}\//,"#{@root}/")
      end
   
      def parse_feature
        @open_comment_block = false
   
        @lines.each do |line|
          next if @open_comment_block && line !~ PY_STRING_LINE
   
          case line
          when PY_STRING_LINE
            # toggle, to declare the multiline comment 'heredoc' open or closed
            @open_comment_block = !@open_comment_block
          when TAG_LINE
            # may be more than one tag line
            @current_tags |= clean_cuke_line($1).split(/\s+/)
          when @lang.feature_line
            @feature = new_feature_node(clean_cuke_line($1), file_relative_path)
            @current_tags = []
          when @lang.scenario_line
            # How do we know when we have read all the lines from a "Scenario Outline:"?
            # One way is when we encounter a "Scenario:"
            close_scenario_outline
   
            handle_scenario_line(clean_cuke_line($1))
            @current_tags = []
          when @lang.scenario_outline_line
            # ... another is when we hit a subsequent "Scenario Outline:"
            close_scenario_outline
   
            @scenario_outline  = new_scenario_outline_node(clean_cuke_line($1))
            @current_tags = []
          when @lang.examples_line
            handle_example_set_line if @example_set
   
            @example_set = new_example_set_node(clean_cuke_line($1))
            @current_tags = []
          when @example_set && EXAMPLE_LINE
            new_example_line(clean_cuke_line($1))
          end
        end
   
        # EOF is the final way that we know we are finished with a "Scenario Outline"
        close_scenario_outline
        return @feature
      end
   
      def clean_cuke_line(sub_expression)
        sub_expression.strip.escape_apostrophe
      end
    end
  end
end
