# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  class TreeReport < ReportBase

    def report_node
      unless @folders
        @folders = Cuporter::Node.new_node(:Report, @doc, :title => title, :view => view)
        files.each do |file|
          feature = FeatureParser.node(file, @doc, @filter, root_dir)
          if feature && feature.has_children?
            path = feature.file.split(File::SEPARATOR)
            path.pop
            @folders.add_leaf(feature, *path)
          end
        end
      end
      @folders
    end

    def title
      @title || "Cucumber Features, Tree View"
    end

  end
end
