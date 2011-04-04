# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  class Report

    attr_reader :filter, :title

    def initialize(input_file_pattern, filter_args = nil, title = nil)
      @input_file_pattern = input_file_pattern
      @filter = Filter.new(filter_args || {})
      @title = title
      @doc = new_doc
    end

    def root_path
      path = @input_file_pattern.split(File::SEPARATOR)
      path.first
    end

    def files
      Dir[@input_file_pattern].collect {|f| File.expand_path f}
    end

    def self.create(type, input_file_pattern, filter_args = nil, title = nil)
      klass = Cuporter.const_get("#{type.downcase}Report".to_class_name)
      klass.new(input_file_pattern, filter_args, title)
    end

    def xml
      @doc.root << body
      @doc.to_xml
    end

    private

    def report_node
      report = new_node(:report)
      files.each do |file|
        report << new_node(:feature) << File.read(file)
      end
    end

    def body
      b = new_node(:body)
      b << report_node
      b
    end

    def new_doc
      doc = Nokogiri::XML::Document.new
      doc << Nokogiri::XML::Node.new(root_path, doc)
      doc
    end
    
    def new_node(name, attributes = {})
      n = Nokogiri::XML::Node.new(name.to_s, @doc)
      attributes.each do | attr, value |
        n[attr.to_s] = value.to_s
      end
      n
    end
    
  end
end
