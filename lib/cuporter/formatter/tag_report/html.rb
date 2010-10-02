# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Formatter
    module TagReport
      class Html < Writer
        include HtmlMethods

        def report_node_writer
          Cuporter::Formatter::TagReport::HtmlNodeWriter
        end

        def title
          "Cucumber Tags"
        end

        def inline_style
          inline_file("tag_report/style.css")
        end

        def header(body)
          body.div(:class => :cuporter_header) do |header|
            label(header)

            body.div(:id => "expand-collapse") do |div|
              div.p("Expand Tags", :id => :expand_tags)
              div.p("Expand All", :id => :expand_all)
              div.p("Collapse All", :id => :collapser)
            end
          end
        end

      end
    end
  end
end
