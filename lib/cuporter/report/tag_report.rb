# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  class TagReport < ReportBase

    def build_report_node
      files.each do |file|
        FeatureParser.tag_nodes(file, report, @filter, root_dir)
      end
      report.sort_all_descendants!
    end

    def report
      @report ||= begin
                    r = Cuporter::Node.new_node(:Report, doc, :title => title)
                    doc.add_report r
                    r
                  end
    end

    def title
      @title || "Cucumber Features, Tag View"
    end

    def build
      build_report_node
      doc
    end

  end
end
