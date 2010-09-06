# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
require 'rubygems'
require 'erb'

module Cuporter
  module Formatters
    class Html < Writer

      def inline_style
        File.read("lib/cuporter/formatters/cuporter.css")
      end

      def get_binding
        binding
      end

      def rhtml
        ERB.new(RHTML)
      end

      def write
        @output.puts rhtml.result(get_binding).reject {|line| /^\s+$/ =~ line}
      end

      RHTML = %{
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Cucumber Tags</title>
    <style type="text/css">
      <%= inline_style%>
    </style>
</head>
<body>
    <ul class="tag_list">
      <%= HtmlNodeWriter.new.write_nodes(@report, @number_scenarios)%>
    </ul>
</body>
</html>
      }


    end
  end
end
