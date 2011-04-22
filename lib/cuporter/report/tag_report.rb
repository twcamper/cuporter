# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  class TagReport < ReportBase

    def build_report_node
      files.each do |file|
        FeatureParser.tag_nodes(file, report, @filter, root_dir)
      end
      report.sort_all_descendants!
      report.search(:tag).each {|f| f.number_all_descendants }
      report.total
    end

    def report
      @report ||= begin
                    r = Cuporter::Node.new_node(:Report, doc, :title => title, :view => @doc.view)
                    doc.add_filter_summary(@filter)
                    doc.add_report r
                    r
                  end
    end

    def title
      @title || "Cucumber Tags"
    end

    def build
      build_report_node
      self
    end

  end
end
