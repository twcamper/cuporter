# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
require 'optparse'
require 'fileutils'

module Cuporter
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
        opts.banner = "Usage: example.rb [@options]"

        opts.on("-i", "--in DIR", "directory of *.feature files") do |i|
          @options[:input_dir] = "#{i}/**/*.feature"
        end
        opts.on("--input-file FILE", "full file name with extension: 'path/to/file.feature'") do |file|
          @options[:input_file] = file
        end
        opts.on("-o", "--out FILE", "Output file path") do |o|
          full_path = File.expand_path(o)
          path = full_path.split(File::SEPARATOR)
          file = path.pop
          FileUtils.makedirs(path.join(File::SEPARATOR))

          @options[:output] = full_path
        end
        opts.on("-f", "--format [pretty|html|csv]", "Output format") do |f|
          @options[:format] = f.downcase.to_class_name
        end
        @options[:format] ||= :Text
        
      end.parse!


    end
  end
end
