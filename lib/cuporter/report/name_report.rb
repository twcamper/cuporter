# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  class NameReport < Report

    def report_node
      filter = Filter.new({})
      names = TagListNode.new("report", filter)
      files.each do |file|
        feature = FeatureParser.name_list(file, filter)
        names.add_child(feature) if feature
      end
      names.sort_all_descendants!
      names
    end

  end
end
