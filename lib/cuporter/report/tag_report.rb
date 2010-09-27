# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  class TagReport < Report

    def report_node
      tags = TagListNode.new("report",[])
      files.each do |file|
        feature = FeatureParser.tag_list(file)
        tags.merge_tag_nodes(feature) if feature
      end
      tags.sort_all_descendants!
      tags.children.each { |child| child.number_all_descendants } if number_scenarios
      tags
    end

  end
end
