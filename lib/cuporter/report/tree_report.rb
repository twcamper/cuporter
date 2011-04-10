# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  class TreeReport < Report

    def report_node
      folders = Cuporter::Node.new_node(:Report, @doc)
      files.each do |file|
        parser = Cuporter::NodeParser.new(file, @doc, @filter)
        parser.root = root_dir
        feature = parser.parse_feature
        if feature && feature.has_children?
          path = parser.file_relative_path.split(File::SEPARATOR)
          path.pop
          folders.add_leaf(feature, *path.map {|dir| [:Dir, dir.upcase]})
        end
      end
      folders.sort_all_descendants!
      folders.total
      folders.number_all_descendants
      folders
    end

    def write
      doc.root << report_node
      doc.write
    end
  end
end
