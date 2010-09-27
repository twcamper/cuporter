# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  class Report

    attr_reader :filter

    def initialize(input_file_pattern, filter_args = nil)
      @input_file_pattern = input_file_pattern
      @filter = Filter.new(filter_args || {})
    end

    def files
      Dir[@input_file_pattern].collect {|f| File.expand_path f}
    end

    def self.create(type, input_file_pattern, filter_args = nil)
      klass = Cuporter.const_get("#{type.downcase}Report".to_class_name)
      klass.new(input_file_pattern, filter_args)
    end
  end
end
