# Copyright 2011 ThoughtWorks, Inc. Licensed under the MIT License
require 'gherkin/i18n'
module Cuporter
  module FeatureParser
    class Language

      def initialize(line_1)
        @iso_code = line_1.to_s =~ LANGUAGE_LINE ? $1 : 'en'
      end

      def feature_pattern
        pattern('feature')
      end
      alias :feature_line :feature_pattern

      def scenario_pattern
        pattern('scenario')
      end
      alias :scenario_line :scenario_pattern

      def scenario_outline_pattern
        pattern('scenario_outline')
      end
      alias :scenario_outline_line :scenario_outline_pattern

      def examples_pattern
        pattern('examples')
      end
      alias :examples_line :examples_pattern

      private
      def pattern(keyword)
        /^\s*((#{Gherkin::I18n::LANGUAGES[@iso_code][keyword]}):[^#]*)/u
      end

      
      LANGUAGE_LINE = /^\s*#\s*language:\s*([\w-]+)/u
    end
  end
end
