# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
require 'rubygems'
require 'erb'

module Cuporter
  module Formatters
    class Html < Writer

      def inline_style
        File.read(File.dirname(__FILE__) + "/cuporter.css")
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

      def inline_jquery
        File.read(File.dirname(__FILE__) + '/jquery-min.js')
      end
      
      def inline_js_content
        <<-EOF

  FEATURES = "li.feature .feature_name";
  TAGS = "li.tag .tag_name";
  
  $(document).ready(function() {
    $(FEATURES).css('cursor', 'pointer');
    $(FEATURES).click(function() {
      $(this).siblings().toggle(250);
    });

    $(TAGS).css('cursor', 'pointer');
    $(TAGS).click(function() {
      $(this).siblings().toggle(250);
    });

    $("#collapser").css('cursor', 'pointer');
    $("#collapser").click(function() {
      $(TAGS).siblings().hide();
      $(FEATURES).siblings().hide();
    });
    
    $("#expand_tags").css('cursor', 'pointer');
    $("#expand_tags").click(function() {
      $(TAGS).siblings().show();
      $(FEATURES).siblings().hide();
    });

    $("#expand_all").css('cursor', 'pointer');
    $("#expand_all").click(function() {
      $(TAGS).siblings().show();
      $(FEATURES).siblings().show();
    });

    // load page with features collapsed
    $("#expand_tags").click();
  })
  
        EOF
      end

      RHTML = %{
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Cucumber Tags</title>
    <style type="text/css">
      <%= inline_style%>
    </style>
    <script type="text/javascript">
      <%= inline_jquery%>
      <%= inline_js_content%>
    </script>
</head>
<body>
    <div class="cuporter_header">
      <div id="label">
          <h1>Cucumber Tags</h1>
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
