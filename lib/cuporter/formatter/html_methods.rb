# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
require 'rubygems'
require 'erb'

module Cuporter
  module Formatter
    module HtmlMethods

      def builder
        @builder ||= Builder::XmlMarkup.new
      end

      def document
        builder.declare!(:DOCTYPE, :html,
                         :PUBLIC, "-//W3C//DTD XHTML 1.0 Transitional//EN",
                         "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
        )
        builder
      end

      def html
        document.html(:xmlns => "http://www.w3.org/1999/xhtml") do |html|
          head(html)
          body(html)
        end.to_s.sub("<to_s/>",'')
      end

      def head(html)
        html.head do |head|
          head.title(title)
          head.style(inline_file("cuporter.css"))
          head.style(inline_style)
          head.script(:type => "text/javascript") do
            head << inline_jquery  # jquery is corrupted if it isn't handled this way
            head << inline_js_content
          end
        end
      end
      
      def body(html)
        html.body do |body|
          header(body)
          body.ul(:class => :main_list) do |ul|
            write_report_node(body)
          end
        end
      end

      def label(header)
        header.div(:id => :label) do |div|
          div.h1(title)
        end
      end

      def inline_file(file_name)
        File.read("#{File.dirname(__FILE__)}/#{file_name}")
      end

      def write_report_node(body)
        report_node_writer.new(body).write_nodes(@report)
      end

      def write
        @output.puts html
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
