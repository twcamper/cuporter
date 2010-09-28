# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
require 'rubygems'
require 'erb'

module Cuporter
  module Formatter
    module NameReport
      class Html < Writer
        include HtmlMethods

        def title
          @report.title
        end

        def filter_summary
          return if @report.filter.empty?
          builder = Builder::XmlMarkup.new
          builder.div(:id => :filter_summary) do |div|
            div.p("Filtering:")
            div.p("Include: #{@report.filter.all.join(' AND ')}") unless @report.filter.all.empty?
            div.p("Include: #{@report.filter.any.join(' OR ')}") unless @report.filter.any.empty?
            div.p("Exclude: #{@report.filter.none.join(', ')}") unless @report.filter.none.empty?
          end
        end

        RHTML = %{
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title><%= title %></title>
    <style type="text/css">
      <%= inline_style%>
    </style>
    <script type="text/javascript">
      <%= inline_jquery%>
      <%= inline_js_content%>
    </script>
</head>
<body class="name_report">
    <div class="cuporter_header">
      <div id="label">
          <h1><%= title %></h1>
      </div>
      <%= filter_summary %>
      <div id="summary">
          <p id="total"><%= @report.report_node.total%> Scenarios </p>
          <div id="expand-collapse">
              <p id="expand_features">Expand All</p>
              <p id="collapse_features">Collapse All</p>
           </div>
      </div>
    </div>
    <ul class="tag_list, name_report">
      <%= Cuporter::Formatter::NameReport::HtmlNodeWriter.new.write_nodes(@report)%>
    </ul>
</body>
</html>
      }


      end
    end
  end
end
