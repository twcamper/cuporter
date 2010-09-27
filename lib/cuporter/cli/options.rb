# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
require 'optparse'
require 'fileutils'

module Cuporter
  module CLI
    class Options

      def self.[](key)
        self.options[key]
      end

      def self.options
        self.parse unless @options
        @options
      end

      def self.parse
        @options = {}
        OptionParser.new(ARGV.dup) do |opts|
          opts.banner = "Usage: cuporter [options]\n\n"

          @options[:input_dir] = "features/**/*.feature"
          opts.on("-i", "--in DIR", "directory of *.feature files\n\t\t\t\t\tDefault: features/**/*.feature\n\n") do |i|
            @options[:input_dir] = "#{i}/**/*.feature"
          end

          opts.on("-I", "--input-file FILE", "full file name with extension: 'path/to/file.feature'\n\n") do |file|
            @options[:input_file] = file
          end
          opts.on("-o", "--out FILE", "Output file path\n\n") do |o|
            full_path = File.expand_path(o)
            path = full_path.split(File::SEPARATOR)
            file = path.pop
            FileUtils.makedirs(path.join(File::SEPARATOR))

            @options[:output] = full_path
          end
          @options[:format] = "text"
          opts.on("-f", "--format [pretty|html|csv]", "Output format\n\t\t\t\t\tDefault: pretty text\n\n") do |f|
            @options[:format] = f
          end

          opts.on("-n", "--numbers", "number scenarios and examples\n\n") do |n|
            @options[:numbers] = n
          end

          @options[:tags] = []
          opts.on("-t", "--tags TAG_EXPRESSION", "Filter on tags for name report.\n\t\t\t\t\tTAG_EXPRESSION rules: see '$ cucumber --help' and http://github.com/aslakhellesoy/cucumber/wiki/Tags\n\n") do |t|
            @options[:tags] << t
          end

          @options[:report] = "tag"
          opts.on("-r", "--report [tag|name]", "type of report\n\t\t\t\t\tDefault: tag\n\n") do |r|
            @options[:report] = r
          end

          @options[:title] = "Cucumber Scenario Inventory"
          opts.on("-T", "--title STRING", "title of name report\n\t\t\t\t\tDefault: 'Cucumber Scenario Inventory'\n\n") do |title|
            @options[:title] = title
          end

        end.parse!


      end
    end
  end
end
