# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
require 'rubygems'
require 'erb'

module Cuporter
  module Formatter
    class TagReportHtml < Writer
      include HtmlMethods

      def title
        "Cucumber Tags"
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
<body class="tag_report">
    <div class="cuporter_header">
      <div id="label">
          <h1><%= title %></h1>
      </div>
          <div id="expand-collapse">
             <p id="expand_tags">Expand Tags</p>
             <p id="expand_all">Expand All</p>
             <p id="collapser">Collapse All</p>
          </div>
    </div>
    <ul class="tag_list">
      <%= HtmlNodeWriter.new.write_nodes(@report, @number_scenarios)%>
    </ul>
</body>
</html>
      }


    end
  end
end
