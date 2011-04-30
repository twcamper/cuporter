# Copyright 2011 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Document
    module Html
      attr_accessor :view

      def add_report(node)
        root << head(node['title'])
        body = new_node('body')
        body << node
        root << body
      end

      # remove CDATA tags so CSS works
      def to_html(options = {})
        to_xhtml(options).gsub(/(<!\[CDATA\[|\]\]>)/,'')
      end

      private

      def head(title_text)
        h = new_node(:head)
        title = new_node(:title)
        title.content = title_text
        h << title

        case view
        when "tree"
          h << link_js("javascripts/jquery-min.js")
          h << link_js("jquery.treeview/jquery.treeview.js")
          h << link_css("jquery.treeview/jquery.treeview.css")
          h << link_js("javascripts/treeview-loader.js")
          h << link_css("stylesheets/cuporter.css")
          h << link_css("stylesheets/#{view}_style.css")
        else
          h << script_js("javascripts/jquery-min.js")
          h << style_css("stylesheets/cuporter.css")
          h << style_css("stylesheets/#{view}_style.css")
          h << script_js("javascripts/expand-collapse.js")
        end
        h
      end

      def assets_dir
        @assets_dir ||= File.expand_path('public', File.dirname(__FILE__) + "/../../../")
      end

      def style_css(file)
        style = new_node('style', 'type' => 'text/css')
        style << file_contents("#{assets_dir}/#{file}")
        style
      end

      def script_js(file)
        script = new_node('script', 'type' => 'text/javascript')
        script << file_contents("#{assets_dir}/#{file}")
        script
      end

      def link_css(file)
        new_node('link', 'type' => 'text/css', 'rel' => 'stylesheet', 'href' => "#{assets_dir}/#{file}")
      end

      def link_js(file)
        new_node('script', 'type' => 'text/javascript', 'src' => "#{assets_dir}/#{file}")
      end

      def file_contents(file_name)
        create_cdata("\n#{File.read(file_name)}")
      end

      def new_node(name, attributes = {})
        n = Nokogiri::XML::Node.new(name.to_s, self)
        attributes.each do | attr, value |
          n[attr.to_s] = value.to_s
        end
        n
      end
    end
  end
end

