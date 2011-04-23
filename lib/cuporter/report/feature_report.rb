# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  class FeatureReport < ReportBase

    def report_node
      unless @report
        @report = Cuporter::Node.new_node(:Report, @doc, :title => title, :view => view)
        files.each do |file|
          feature = FeatureParser.node(file, @doc, @filter, root_dir)
          if feature && feature.has_children?
            @report.add_child feature
          end
        end
      end
      @report
    end

    def title
      @title || "Cucumber Features, List View"
    end

  end
end
