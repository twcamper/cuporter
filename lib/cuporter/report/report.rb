# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  class Report

    def initialize(input_file_pattern, filter_args = nil)
      @input_file_pattern = input_file_pattern
      @filter = Filter.new(filter_args || {})
    end

    def files
      Dir[@input_file_pattern].collect {|f| File.expand_path f}
    end
  end
end
