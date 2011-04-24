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
        unless @options
          self.parse 
          @options[:input_file_pattern] = @options.delete(:input_file) || "#{@options.delete(:input_dir)}/**/*.feature"
          @options[:root_dir] = @options[:input_file_pattern].split(File::SEPARATOR).first
          @options[:filter_args] = Cuporter::CLI::FilterArgsBuilder.new(@options.delete(:tags)).args
        end
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

          @options[:report] = "tag"
          opts.on("-r", "--report [tag|feature|tree]", %Q{View, or type of report.
                                         Default: "tag"
          }) do |r|
            @options[:report] = r
          end

          @options[:format] = "text"
          opts.on("-f", "--format [xml|html|csv|text]", %Q{Output format.
                                         Default: text (it's pretty, though!)
          }) do |f|
            @options[:format] = f
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

          opts.on("-I", "--file-input FILE", %Q{Single *.feature file.  Full name with extension, like 'path/to/file.feature.'
                                         Overrides "--input-dir" and used mostly for testing.
          }) do |file|
            @options[:input_file] = file
          end
          
          @options[:output_file]
          opts.on("-o", "--output-file FILE", %Q{Output file path, like 'tmp/cucumber/tag_report.html'.
          }) do |o|
            full_path = File.expand_path(o)
            path = full_path.split(File::SEPARATOR)
            file = path.pop
            FileUtils.makedirs(path.join(File::SEPARATOR))
            
            @options[:output_file] = full_path
          end

          @options[:tags] = []
          opts.on("-t", "--tags TAG_EXPRESSION", %Q{Filter on tags for name report.
                                         TAG_EXPRESSION rules:
                                             1. $ cucumber --help
                                             2. http://github.com/aslakhellesoy/cucumber/wiki/Tags
          }) do |t|
            @options[:tags] << t
          end

          opts.on("-T", "--title STRING", %Q{Override report default title, which is different for each view/report.
                                         This affects the xml 'report' node title and the html head > title attributes.
          }) do |title|
            @options[:title] = title
          end

          opts.separator "Reporting options: on by default but can be turned off:\n\n"
          @options[:sort] = true
          opts.on("--no-sort", "Do not sort tags, features, scenarios, or outlines\n") do |n|
            @options[:sort] = n
          end

          @options[:number] = true
          opts.on("--no-number", "Do not get or show scenario or example numbers, (i.e., do not number the leaf nodes).\n") do |n|
            @options[:number] = n
          end

          @options[:total] = true
          opts.on("--no-total", "Do not get or show totals\n") do |n|
            @options[:total] = n
          end

          @options[:show_tags] = true
          opts.on("--no-show-tags", "Do not show cucumber tags at the feature, scenario, or outline level.\n") do |show_tags|
            @options[:show_tags] = show_tags
          end

          @options[:show_files] = true
          opts.on("--no-show-files", "Do not show feature file paths.\n") do |show_files|
            @options[:show_files] = show_files
          end

          @options[:leaves] = true
          opts.on("--no-leaves", "Show features only, with no scenarios or outlines.\n\n\n") do |l|
            @options[:leaves] = l
          end

        end.parse!

      end
    end
  end

  def self.html?
    CLI::Options[:format] == 'html'
  end

  def self.options
    CLI::Options.options
  end

  def self.output_file
    if options[:output_file]
      File.open(options[:output_file], "w")
    end
  end
end
