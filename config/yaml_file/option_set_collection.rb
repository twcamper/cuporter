# Copyright 2011 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Config
    module YamlFile
      class OptionSetCollection

        def self.path
          Cuporter::Config::CLI::Options[:config_file] || "config/cuporter.yml"
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

      end # class
    end  # File
  end  # Config
end
