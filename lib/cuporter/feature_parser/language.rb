# Copyright 2011 ThoughtWorks, Inc. Licensed under the MIT License
begin
  require 'gherkin/i18n'
rescue LoadError => ex
  $gherkin_warning = %Q{Warning: Rubygems could not find Gherkin.  Cuporter will use an old gherkin (2.3.3) language file.
         Make sure the 'gherkin' gem is installed by checking your rvm config, your bundler config, or gem list.

         "#{ex.class}: #{ex.message}"
         "#{ex.backtrace.join("\n\t\t")}"
  }
  require 'lib/cuporter/feature_parser/old_gherkin_yaml/i18n'
end

module Cuporter
  module FeatureParser
    class Language

      attr_reader :feature_line, :scenario_line, :scenario_outline_line, :examples_line

      def initialize(line_1)
        @iso_code = 'en'
        if (line_1.to_s =~ LANGUAGE_LINE)
          @iso_code = $1
          warn($gherkin_warning) if $gherkin_warning
        end
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
