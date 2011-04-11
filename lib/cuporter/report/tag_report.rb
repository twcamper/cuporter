# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  class TagReport < ReportBase

    def build_report_node
      files.each do |file|
        FeatureParser.tag_nodes(file, report, @filter)
      end
      report.sort_all_descendants!
    end

    def report
      @report ||= begin
                    r = Cuporter::Node.new_node(:Report, doc)
                    doc.root << r
                    r
                  end
    end

    def write
      build_report_node
      doc.write
    end

  end
end
