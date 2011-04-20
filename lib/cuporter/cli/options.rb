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

      def self.args
        @@args
      end

      def self.parse
        @@args = ARGV.dup
        @options = {}
        OptionParser.new(ARGV.dup) do |opts|
          opts.banner = "Usage: cuporter [options]\n\n"

          opts.on("-o", "--out FILE", "Output file path\n\n") do |o|
            full_path = File.expand_path(o)
            path = full_path.split(File::SEPARATOR)
            file = path.pop
            FileUtils.makedirs(path.join(File::SEPARATOR))

            @options[:output] = full_path
          end
          @options[:format] = "text"
          opts.on("-f", "--format [xml|html|csv|text]", "Output format: Default: text (it's pretty, though!)\n\n") do |f|
            @options[:format] = f
          end

          opts.on("-I", "--file-input FILE", %Q{Full file name with extension: 'path/to/file.feature.'
                                     Overrides --input-dir and used mostly for testing.
          }) do |file|
            @options[:input_file] = file
          end
          
          opts.on("-n", "--numbers", "number scenarios and examples\n\n") do |n|
            @options[:numbers] = n
          end

          @options[:tags] = []
          opts.on("-t", "--tags TAG_EXPRESSION", "Filter on tags for name report.\n\t\t\t\t\tTAG_EXPRESSION rules: see '$ cucumber --help' and http://github.com/aslakhellesoy/cucumber/wiki/Tags\n\n") do |t|
            @options[:tags] << t
          end

          @options[:report] = "tag"
          opts.on("-r", "--report [tag|name|tree]", "type of report\n\t\t\t\t\tDefault: tag\n\n") do |r|
            @options[:report] = r
          end

          opts.on("-T", "--title STRING", "title of name report\n\t\t\t\t\tDefault: 'Cucumber Features, [Tag|Tree|List] View'\n\n") do |title|
            @options[:title] = title
          end
          @options[:input_dir] = "features"
          opts.on("-i", "--input-dir DIR", %Q{Root directory of *.feature files.
                                     Default: "features"

                                     Used to build the glob pattern '[--in]/**/*.feature', which is really most likely
                                     "features/**/*.features" and finds all feature files anywhere under "features" or
                                     your custom root supplied with this option.
                                     Overridden by "--file-input'.
          }) do |i|
            @options[:input_dir] = i.sub(/#{File::SEPARATOR}$/,'')
          end


        end.parse!

        def self.input_file_pattern
          options[:input_file] || "#{options[:input_dir]}/**/*.feature"
        end

      end
    end
  end

  def self.html?
    CLI::Options[:format] == 'html'
  end

  def self.options
    CLI::Options.options
  end
end
