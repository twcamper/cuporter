# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  class FeatureReport < Report

    private

    def report_node
      report = new_node(:Report)
      files.each do |file|
        feature = FeatureParser.node(file, @doc, @filter)
        if feature && feature.has_children?
          report << feature
        end
      end
      report.sort_all_descendants!
      report.number_all_descendants
      report.total
      report
    end

    
    def new_node(name, attributes = {})
      Cuporter::Node.new_node(name, @doc, attributes)
    end
  end
end
