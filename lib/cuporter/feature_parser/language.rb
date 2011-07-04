# Copyright 2011 ThoughtWorks, Inc. Licensed under the MIT License
require 'gherkin/i18n'
module Cuporter
  module FeatureParser
    class Language

      attr_reader :feature_line, :scenario_line, :scenario_outline_line, :examples_line

      def initialize(line_1)
        @iso_code = line_1.to_s =~ LANGUAGE_LINE ? $1 : 'en'
        @feature_line          = pattern_for('feature')
        @scenario_line         = pattern_for('scenario')
        @scenario_outline_line = pattern_for('scenario_outline')
        @examples_line         = pattern_for('examples')
      end

      private

      def pattern_for(keyword)
        /^\s*((#{Gherkin::I18n::LANGUAGES[@iso_code][keyword]}):[^#]*)/u
      end
      
      LANGUAGE_LINE = /^\s*#\s*language:\s*([\w-]+)/u
    end
  end
end
