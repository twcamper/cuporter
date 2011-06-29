# Copyright 2011 ThoughtWorks, Inc. Licensed under the MIT License
$LOAD_PATH.unshift( File.expand_path("#{File.dirname(__FILE__)}"))
require 'fileutils'
require 'cli/options'
require 'cli/filter_args_builder'

module Cuporter
  module Config

    class OptionSetCollection

      def self.path
        Cuporter::Config::CLI::Options[:config_file] || "cuporter.yml"
      end

      def self.config_file
        return [] unless File.exists?(path)

        require 'yaml'
        yaml = YAML.load_file(path)
        if yaml["option_sets"]
          yaml["option_sets"].map do |option_set|
            cast(option_set["options"])
          end
        else
          yaml["defaults"].empty? ? [] : [cast(yaml["defaults"])]
        end
      end

      def self.cast(option_set)
        pairs = {}
        option_set.each do |key, value|
          pairs[key.to_sym] = case key
                              when /^(tags|output_file|format)$/i
                                value.is_a?(Array) ? value : [value]
                              else
                                value
                              end
        end
 
        return pairs
      end
    end

    class OptionSet

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
                   :leaves                   => true
      }

      attr_reader :options

      def initialize(file_config = {})
        # CLI options replace any found in the file
        cli_options_over_file_options = file_config.merge(Cuporter::Config::CLI::Options.options)

        # defaults will be used for anything not so far specified in the file
        # or CLI
        @options = post_process(DEFAULTS.merge(cli_options_over_file_options))
      end

      def [](key)
        @options[key]
      end

      def output_file(format)
        if (file = @options[:output_file].find {|f| f =~ ext_for(format) })
          File.open(file, "w")
        end
      end

      def dump
        col_1_max = @options.keys.max_by {|i| i.to_s.length }.to_s.size
        @options.each do |key, value|
          puts ":#{key.to_s.ljust(col_1_max, ' ')} => #{value.inspect}"
        end
      end

      def dry_run?
        @options[:dry_run]
      end

      private

      def post_process(options)
        options[:input_file_pattern] = options.delete(:input_file) || "#{options.delete(:input_dir)}/**/*.feature"
        options[:root_dir] = options[:input_file_pattern].split(File::SEPARATOR).first
        options[:filter_args] = Cuporter::Config::CLI::FilterArgsBuilder.new(options.delete(:tags)).args
        options[:output_file].each_with_index do |file_path, i|
          options[:output_file][i] = full_path(options[:output_home], file_path.dup )
        end

        unless options[:output_file].find {|f| f =~ /\.html$/ }
          options[:copy_public_assets] = options[:use_copied_public_assets] = false
        end

        options
      end

      def full_path(root_dir, file_path)
        path = root_dir.empty? ? file_path : File.join(root_dir, file_path)
        expanded_path = File.expand_path(path)
        path_nodes = expanded_path.split(File::SEPARATOR)
        file = path_nodes.pop
        FileUtils.makedirs(path_nodes.join(File::SEPARATOR))
        expanded_path
      end

      def ext_for(format)
        case format
        when 'text', 'pretty'
          /\.txt$/
        else
          /\.#{format}$/
        end
      end
    end
  end

  def self.option_sets
    if (yaml_hashes = Config::OptionSetCollection.config_file).any?
      yaml_hashes.map {|set| Config::OptionSet.new(set) }
    else
      [Config::OptionSet.new]
    end
  end


end
