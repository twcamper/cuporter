# Copyright 2011 ThoughtWorks, Inc. Licensed under the MIT License
$LOAD_PATH.unshift( File.expand_path("#{File.dirname(__FILE__)}"))
require 'fileutils'
require 'cli/options'
require 'cli/filter_args_builder'

module Cuporter
  module Config

    module Options

      DEFAULTS = { :report => "tag",
                   :format => ["text"],
                   :input_dir => "features",
                   :output_file => [],
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
        options[:output_file].each_with_index do |file_path, i|
          options[:output_file][i] = full_path(file_path.dup)
        end

        unless options[:output_file].find {|f| f =~ /\.html$/ }
          options[:copy_public_assets] = options[:use_copied_public_assets] = false
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

  def self.ext_for(format)
    case format
    when 'text', 'pretty'
      /\.txt$/
    else
      /\.#{format}$/
    end
  end

  def self.output_file(format)
    if (file = options[:output_file].find {|f| f =~ ext_for(format) })
      File.open(file, "w")
    end
  end
end
