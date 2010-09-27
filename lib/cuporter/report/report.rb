# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  class Report

    attr_reader :number_scenarios, :filter, :title

    def initialize(input_file_pattern, number_scenarios, filter_args = nil, title = nil)
      @input_file_pattern = input_file_pattern
      @number_scenarios = number_scenarios
      @filter = Filter.new(filter_args || {})
      @title = title
    end

    def files
      Dir[@input_file_pattern].collect {|f| File.expand_path f}
    end

    def self.create(type, input_file_pattern, number_scenarios, filter_args = nil, title = nil)
      klass = Cuporter.const_get("#{type.downcase}Report".to_class_name)
      klass.new(input_file_pattern, number_scenarios, filter_args, title)
    end
  end
end
