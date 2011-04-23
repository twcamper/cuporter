# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  class FeatureReport < ReportBase

    def report_node
      report = Cuporter::Node.new_node(:Report, @doc, :title => title, :view => @doc.view)
      files.each do |file|
        feature = FeatureParser.node(file, @doc, @filter, root_dir)
        if feature && feature.has_children?
          report.add_child feature
        end
      end
      report.sort_all_descendants!
      report.number_all_descendants
      report.total
      report.defoliate if no_leaves
      report
    end

    def title
      @title || "Cucumber Features, List View"
    end

    def build
      doc.add_filter_summary(@filter)
      doc.add_report report_node
      self
    end

  end
end
