# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Formatter
    module NameReport
      class Html < Writer
        include HtmlMethods

        def report_node_writer
          Cuporter::Formatter::NameReport::HtmlNodeWriter
        end

        def title
          @report.title
        end

        def header(body)
          body.div(:class => :cuporter_header) do |header|
            label(header)
            filter_summary(header)
            header.div(:id => :summary) do |div|
              div.p("#{@report.report_node.total} Scenarios", :id => :total)
              div.div(:id => "expand-collapse") do |exp_col|
                exp_col.p("Expand All", :id => :expand_features)
                exp_col.p("Collapse All", :id => :collapse_features)
              end
            end
          end
        end

        def filter_summary(builder)
          return if @report.filter.empty?
          builder.div(:id => :filter_summary) do |div|
            div.p("Filtering:")
            div.p("Include: #{@report.filter.all.join(' AND ')}") unless @report.filter.all.empty?
            div.p("Include: #{@report.filter.any.join(' OR ')}") unless @report.filter.any.empty?
            div.p("Exclude: #{@report.filter.none.join(', ')}") unless @report.filter.none.empty?
          end
        end

        def inline_style
          inline_file("name_report/style.css")
        end
        

      end
    end
  end
end
