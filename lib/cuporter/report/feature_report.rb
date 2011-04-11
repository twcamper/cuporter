# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  class FeatureReport < ReportBase

    def report_node
      report = Cuporter::Node.new_node(:Report, @doc)
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

    def write
      doc.root << report_node
      doc.write
    end

  end
end
