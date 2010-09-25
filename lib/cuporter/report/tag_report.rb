# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  class TagReport < Report

    def report_node
      tags = TagListNode.new("report",[])
      files.each do |file|
        feature = FeatureParser.parse(file)
        tags.merge(feature) if feature
      end
      tags.sort_all_descendants!
      tags
    end

  end
end
