# Copyright 2011 ThoughtWorks, Inc. Licensed under the MIT License
$LOAD_PATH.unshift( File.expand_path("#{File.dirname(__FILE__)}"))
require 'fileutils'
require 'cli/options'
require 'cli/filter_args_builder'

module Cuporter
  module Config

    module Options

      DEFAULTS = { :report => "tag",
                   :format => "text",
                   :input_dir => "features",
                   :tags => [],
                   :copy_public_assets => false,
                   :use_copied_public_assets => false,
                   :sort => true,
                   :number => true,
                   :total => true,
                   :show_tags => true,
                   :show_files => true,
                   :leaves => true
      }

      def self.options
        unless @options
          # empty hash if no file
          file_config = config_file(Cuporter::Config::CLI::Options[:config_file] || "cuporter.yml")

          # CLI options replace any found in the file
          cli_options_over_file_options = file_config.merge(Cuporter::Config::CLI::Options.options)

          # defaults will be used for anything not so far specified in the file
          # or CLI
          @options = post_process(DEFAULTS.merge(cli_options_over_file_options))
        end
        @options
      end

      def self.post_process(options)
        options[:input_file_pattern] = options.delete(:input_file) || "#{options.delete(:input_dir)}/**/*.feature"
        options[:root_dir] = options[:input_file_pattern].split(File::SEPARATOR).first
        options[:filter_args] = Cuporter::Config::CLI::FilterArgsBuilder.new(options.delete(:tags)).args
        if options[:output_file]
          options[:output_file] = full_path(options[:output_file].dup)
        else
          options[:copy_public_assets] = false
          options[:use_copied_public_assets] = false
        end
        options
      end

      def self.config_file(path)
        return {} unless File.exists?(path)

        require 'yaml'
        pairs = {}
        YAML.load_file(path).each do |key, value|
          pairs[key.to_sym] = case value
                              when /^true$/i
                                true
                              when /^false$/i
                                false
                              end || value
        end
        pairs
      end

      def self.full_path(path)
        expanded_path = File.expand_path(path)
        path_nodes = expanded_path.split(File::SEPARATOR)
        file = path_nodes.pop
        FileUtils.makedirs(path_nodes.join(File::SEPARATOR))
        expanded_path
      end

    end
  end

  def self.html?
    Config::Options[:format] == 'html'
  end

  def self.options
    Config::Options.options
  end

  def self.output_file
    if options[:output_file]
      File.open(options[:output_file], "w")
    end
  end
end
