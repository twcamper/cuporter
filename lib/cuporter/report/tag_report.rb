# Copyright 2011 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  class TagReport < ReportBase

    def build_report_node
      files.each do |file|
        FeatureParser.tag_nodes(file, report, @filter, root_dir)
      end
    end

    def report
      @report ||= begin
                    r = Cuporter::Node.new_node(:Report, doc, :title => title, :view => view)
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
      report.sort_all_descendants!                             if sort?
      report.search(:tag).each {|f| f.number_all_descendants } if number?
      report.total                                             if total?
      report.move_tagless_node_to_bottom
      report.defoliate!                                        if no_leaves?
      report.remove_files!                                     unless show_files?
      report.remove_tags!                                      unless show_tags?
      self
    end

  end
end
