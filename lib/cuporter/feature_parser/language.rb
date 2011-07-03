# Copyright 2011 ThoughtWorks, Inc. Licensed under the MIT License

module Cuporter
  module FeatureParser
    class Language

      def initialize(line_1)
        @iso_code = line_1.to_s =~ LANGUAGE_LINE ? $1 : 'en'
      end

      def feature_pattern
        /^\s*(Feature:[^#]*)/u
      end
      alias :feature_line :feature_pattern

      def scenario_pattern
        /^\s*(Scenario:[^#]*)$/u
      end
      alias :scenario_line :scenario_pattern

      def scenario_outline_pattern
        /^\s*(Scenario Outline:[^#]*)$/u
      end
      alias :scenario_outline_line :scenario_outline_pattern

      def examples_pattern
        /^\s*((Scenarios|Examples):[^#]*)$/u
      end
      alias :examples_line :examples_pattern

      
      LANGUAGE_LINE         = /^\s*#\s*language:\s*([\w-]+)/u
    end
  end
end
