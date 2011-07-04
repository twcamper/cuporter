# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
require 'optparse'
require 'fileutils'

module Cuporter
  module Config
    module CLI

      class Options

        def self.[](key)
          self.options[key]
        end

        def self.options
          parse unless @options
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

            opts.on("-r", "--report [tag|feature|tree]", %Q{View, or type of report.
                                         Default: "tag"
            }) do |r|
              @options[:report] = (r == 'name' ? 'feature' : r) 
            end

            opts.on("-f", "--format [xml|html|csv|text]", %Q{Output format.
                                         Default: text (it's pretty, though!)
            }) do |f|
              @options[:format] = [] unless @options[:format]
              @options[:format] << f
            end

            opts.on("-i", "--input-dir DIR", %Q{Root directory of *.feature files to be read.
                                         Default: "features"

                                         Used to build the glob pattern '[--input-dir]/**/*.feature', which is really most likely
                                         "features/**/*.features" and finds all feature files anywhere under "features" or
                                         your custom root supplied with this option.
                                         Overridden by "--file-input".
            }) do |i|
              @options[:input_dir] = i.sub(/#{File::SEPARATOR}$/,'')
            end

            opts.on("-I", "--file-input FILE", %Q{Single *.feature file.  Full name with extension, like 'path/to/file.feature.'
                                         Overrides "--input-dir" and used mostly for testing.
            }) do |file|
              @options[:input_file] = file
            end

            opts.on("-H", "--output-home PATH", %Q{Root directory for the output files, like 'tmp/cucumber'.
                                         Optional, because the path can also be specified along with the 
                                         file name in "--output-file"

                                         Default: ""
            }) do |h|
              @options[:output_home] = h
            end

            opts.on("--log-dir PATH", %Q{Root directory for the error log 'cuporter_errors.log'.

                                         Default: "." if no report output file is specified, else same as output file dir.
            }) do |d|
              @options[:log_dir] = d
            end

            opts.on("-o", "--output-file FILE", %Q{Output file path, like 'tmp/cucumber/tag_report.html'.
            }) do |o|
              @options[:output_file] = [] unless @options[:output_file]
              @options[:output_file] << o
            end

            opts.on("-t", "--tags TAG_EXPRESSION", %Q{Filter on tags for name report.
                                         TAG_EXPRESSION rules:
                                             1. $ cucumber --help
                                             2. http://github.com/aslakhellesoy/cucumber/wiki/Tags
            }) do |t|
              @options[:tags] = [] unless @options[:tags]
              @options[:tags] << t
            end

            opts.on("-T", "--title STRING", %Q{Override report default title, which is different for each view/report.
                                         This affects the xml 'report' node title and the html head > title attributes.
            }) do |title|
              @options[:title] = title
            end

            opts.on("--config-file PATH", %Q{Specify any of these options in a yml file.
                                           Order of precedence:
                                              1 - command line
                                              2 - yaml file
                                              3 - these defaults

                                           Default: 'config/cuporter.yml'
            }) do |path|
              @options[:config_file] = path
            end

            opts.on("-d", "--dry-run", %Q{Print the configuration without running any reports.
            }) do |d|
              @options[:dry_run] = d
            end

            opts.on("--text-summary", %Q{Add a summary to the text format.
            }) do |ts|
              @options[:text_summary] = ts
            end

            opts.separator "CSS and Javascript asset options:\n\n"

            opts.on("-l", "--link-assets", %Q{Do not inline CSS and js in <style/> and <script/> tags, but link to external files instead.
                                           Default:  'false' for the tag and feature views, not optional for the
                                                     tree view, which requires external gifs.
            }) do |l|
              @options[:link_assets] = l
            end

            opts.on("-c", "--copy-public-assets", %Q{If --output-file is supplied, and you're linking to external 
                                           CSS and JavaScript assets, copy them from 'public/' to 'cuporter_public'
                                           in the same dir as the output file.
                                           Sets --use-copied-public-assets to 'true', and
                                           the html report will link to these files by relative path.

                                           Default: 'false'
            }) do |c|
              @options[:copy_public_assets] = c
              @options[:use_copied_public_assets] = c
            end

            opts.on("-u", "--use-copied-public-assets", %Q{When running batches of reports, and the assets folder has already been
                                           created by another call to cuporter with '--copy-public-assets'.
                                           Set to 'true' automatically along with --copy-public-assets.

                                           Default: 'false'
            }) do |u|
              @options[:use_copied_public_assets] = u
            end

            opts.separator "Reporting options: on by default but can be turned off:\n\n"
            opts.on("--no-sort", "Do not sort tags, features, scenarios, or outlines\n") do |n|
              @options[:sort] = n
            end

            opts.on("--no-number", "Do not get or show scenario or example numbers, (i.e., do not number the leaf nodes).\n") do |n|
              @options[:number] = n
            end

            opts.on("--no-total", "Do not get or show totals\n") do |n|
              @options[:total] = n
            end

            opts.on("--no-show-tags", "Do not show cucumber tags at the feature, scenario, or outline level.\n") do |show_tags|
              @options[:show_tags] = show_tags
            end

            opts.on("--no-show-files", "Do not show feature file paths.\n") do |show_files|
              @options[:show_files] = show_files
            end

            opts.on("--no-leaves", "Show features only, with no scenarios or outlines.\n\n\n") do |l|
              @options[:leaves] = l
            end

          end.parse!

        end
      end
    end
  end

end
