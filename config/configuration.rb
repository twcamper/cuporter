# Copyright 2011 ThoughtWorks, Inc. Licensed under the MIT License
$LOAD_PATH.unshift( File.expand_path("#{File.dirname(__FILE__)}"))
require 'fileutils'
require 'cli/options'
require 'cli/filter_args_builder'
require 'yaml_file/option_set_collection'
require 'option_set'

module Cuporter
  def self.option_sets
    if (yaml_hashes = Config::YamlFile::OptionSetCollection.config_file).any?
      yaml_hashes.map {|yaml_hash| Config::OptionSet.new(yaml_hash) }
    else
      [Config::OptionSet.new]
    end
  end

  module Config
    DEFAULTS = { :report                   => "tag",
                 :format                   => ["text"],
                 :input_dir                => "features",
                 :output_file              => [],
                 :output_home              => "",
                 :tags                     => [],
                 :link_assets              => false,
                 :copy_public_assets       => false,
                 :use_copied_public_assets => false,
                 :dry_run                  => false,
                 :sort                     => true,
                 :number                   => true,
                 :total                    => true,
                 :show_tags                => true,
                 :show_files               => true,
                 :leaves                   => true }

  end
end
