# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License

module Cuporter
  module FeatureParser
    FEATURE_LINE          = /^\s*(Feature:[^#]+)/
    TAG_LINE              = /^\s*(@\w.+)/
    SCENARIO_LINE         = /^\s*(Scenario:[^#]+)$/
    SCENARIO_OUTLINE_LINE = /^\s*(Scenario Outline:[^#]+)$/
    SCENARIO_SET_LINE     = /^\s*(Scenarios:[^#]*)$/
    EXAMPLE_SET_LINE      = /^\s*(Examples:[^#]*)$/
    EXAMPLE_LINE          = /^\s*(\|.*\|)\s*$/

    def self.tag_list(file)
      TagList.new(file).parse_feature
    end

    def self.name_list(file, filter)
      NameList.new(file, filter).parse_feature
    end

  end
end
