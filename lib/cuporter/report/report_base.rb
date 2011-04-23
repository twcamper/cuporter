# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  class ReportBase

    attr_reader :filter, :doc, :root_dir, :view

    def initialize(options)
      @input_file_pattern = options[:input_file_pattern]
      @doc                = Cuporter::Document.new_xml
      @view               = options[:report]
      @root_dir           = options[:root_dir]
      @filter             = Filter.new(options[:filter_args])
      @title              = options[:title]
      @sort               = options[:sort]
      @total              = options[:total]
      @number             = options[:number]
      @leaves             = options[:leaves]
      @show_files         = options[:show_files]
      @show_tags          = options[:show_tags]
    end

    def no_leaves?
      !@leaves
    end

    def sort?
      @sort
    end

    def total?
      @total
    end

    def number?
      @number
    end

    def show_files?
      @show_files
    end

    def show_tags?
      @show_tags
    end

    def files
      Dir[@input_file_pattern].collect {|f| File.expand_path f}
    end

    def self.create(options)
      klass = Cuporter.const_get("#{options[:report].downcase}Report".to_class_name)
      klass.new(options)
    end

    def build
      report_node.sort_all_descendants!  if sort?
      report_node.number_all_descendants if number?
      report_node.total                  if total?
      report_node.defoliate!             if no_leaves?
      report_node.remove_files!          unless show_files?
      report_node.remove_tags!           unless show_tags?

      doc.add_filter_summary(@filter)
      doc.add_report report_node
      self
    end

  end
end
