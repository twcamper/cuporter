# Copyright 2011 ThoughtWorks, Inc. Licensed under the MIT License
require 'lib/cuporter/feature_parser/language'
require 'lib/cuporter/feature_parser/parser_base'
require 'lib/cuporter/feature_parser/tag_nodes_parser'
require 'lib/cuporter/feature_parser/node_parser'

module Cuporter
  module FeatureParser
    # adds a node to the doc for each cucumber '@' tag, populated with features and
    # scenarios
    def self.tag_nodes(file, report, filter, root_dir)
      parser = TagNodesParser.new(file, report, filter)
      parser.root = root_dir
      parser.parse_feature
    end

    # returns a feature node populated with scenarios
    def self.node(file, doc, filter, root_dir)
      parser = NodeParser.new(file, doc, filter)
      parser.root = root_dir
      parser.parse_feature
    end
  end
end
