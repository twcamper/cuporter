# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  class TreeReport < ReportBase

    def report_node
      folders = Cuporter::Node.new_node(:Report, @doc, :title => title, :view => @doc.view)
      files.each do |file|
        feature = FeatureParser.node(file, @doc, @filter, root_dir)
        if feature && feature.has_children?
          path = feature.file.split(File::SEPARATOR)
          path.pop
          folders.add_leaf(feature, *path.map {|dir| [:Dir, dir.upcase]})
        end
      end
      folders.sort_all_descendants!
      folders.number_all_descendants
      folders.total
      folders
    end

    def title
      @title || "Cucumber Features, Tree View"
    end

    def build
      doc.add_filter_summary(@filter)
      doc.add_report report_node
      self
    end

  end
end
