# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  class TagReport

    def initialize(input_file_pattern)
      @input_file_pattern = input_file_pattern || "features/**/*.feature"
    end

    def files
      Dir[@input_file_pattern].collect {|f| File.expand_path f}
    end

    def scenarios_per_tag
      tags = TagListNode.new("report",[])
      files.each do |file|
        content = File.read(file)
        tags.merge(FeatureParser.parse(content)) unless content.empty?
      end
      tags.sort_all_descendants!
      tags
    end

  end
end
