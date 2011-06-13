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
          @options[:assets_dir]  = path(@options[:assets_dir]) if @options[:assets_dir]
        end
        @options
      end

      def self.args
        @@args
      end

      
      def self.full_path(path)
        expanded_path = File.expand_path(path)
        path_nodes = expanded_path.split(File::SEPARATOR)
        file = path_nodes.pop
        FileUtils.makedirs(path_nodes.join(File::SEPARATOR))
        expanded_path
      end

      def self.path(relative_path)
        p path_nodes = File.expand_path(relative_path).split(File::SEPARATOR)
        file = path_nodes.pop
        p original_wd = Dir.pwd
        FileUtils.cd(@options[:working_dir_html])
        p Dir.pwd
        FileUtils.makedirs(path_nodes.join(File::SEPARATOR))
        FileUtils.cd(original_wd)
        relative_path
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
            @options[:report] = (r == 'name' ? 'feature' : r) 
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
     
                                         Used to build the glob pattern '[--input-dir]/**/*.feature', which is really most likely
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
          
          opts.on("-o", "--output-file FILE", %Q{Output file path, like 'tmp/cucumber/tag_report.html'.
          }) do |o|
            @options[:output_file] = full_path(o)
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

          opts.separator "CSS and Javascript asset options:\n\n"

          @options[:working_dir_html] = '.'
          opts.on("--working-dir-html PATH", %Q{Needed when '--assets-dir' is a relative path.
                                           Default:  '.'
          }) do |d|
            @options[:working_dir_html] = d
          end

          opts.on("-a", "--assets-dir PATH", %Q{Path to folder for CSS and Javascript assets.
                                           Only applies with '--link-assets', which is off by default.
                                           Setting this will cause assets to be copied from 'public';
                                           otherwise, the html will link to the files under 'cuporter/public' in
                                           your gempath.
          }) do |a|
            @options[:assets_dir] = a
          end

          opts.on("-l", "--link-assets", %Q{Do not inline CSS and js in <style/> and <script/> tags, but link to external files instead.
                                           Default:  'false' for the tag and feature views, not optional for the
                                                     tree view, which requires external gifs.
          }) do |l|
            @options[:link_assets] = l
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
