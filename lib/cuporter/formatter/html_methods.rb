# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
require 'rubygems'
require 'erb'

module Cuporter
  module Formatter
    module HtmlMethods

      def inline_file(file_name)
        File.read("#{File.dirname(__FILE__)}/#{file_name}")
      end

      def get_binding
        binding
      end

      def rhtml
        ERB.new(self.class::RHTML)
      end

      def write
        @output.puts rhtml.result(get_binding).reject {|line| /^\s+$/ =~ line}
      end

      def inline_jquery
        inline_file('/jquery-min.js')
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

    $("#expand_features").css('cursor', 'pointer');
    $("#expand_features").click(function() {
      $(FEATURES).siblings().show();
    });

    $("#collapse_features").css('cursor', 'pointer');
    $("#collapse_features").click(function() {
      $(FEATURES).siblings().hide();
    });

    // load page with features collapsed
    $("#collapser, #collapse_features").click();
  })
  
        EOF
      end

    end
  end
end
