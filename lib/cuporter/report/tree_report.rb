# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  class TreeReport < Report

    def report_node
      folders = TagListNode.new("report", @filter)
      files.each do |file|
        parser = NameListParser.new(file, @filter)
        parser.root = root
        feature = parser.parse_feature
        if feature && feature.has_children?
          path = feature.file.split(File::SEPARATOR)
          path.pop
          folders.add_leaf(path, feature)
        end
      end
      folders.sort_all_descendants!
      folders.number_all_descendants
      folders
    end

  end
end
