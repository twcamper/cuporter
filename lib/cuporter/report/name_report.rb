# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  class NameReport < Report

    def report_node
      names = Node.new("report")
      files.each do |file|
        feature = FeatureParser.parse_names(file)
        names.add_child(feature) if feature
      end
      names.sort_all_descendants!
      names
    end

  end
end
