# Copyright 2011 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Document
    module Html

      def formatter
        @formatter ||= Formatter.get_const(view.to_sym)
      end

      def add_report(report_node)
        @title = report_node.delete('title').value
        root << head(@title)
        root << body(report_node)
      end

      def to_html(options = {})
        root.at(:head).to_html + root.at(:body).to_xml(options)
      end

      private

      def head(title_text)
        h = new_node(:head)
        title = new_node(:title)
        title.content = title_text
        h << title
        h << inline_css("cuporter.css")
        h << inline_css("#{view}_style.css")
        h
      end


      def body(report_node)
        b = new_node(:body)
    #    b << formatter.header
        b << report_node
        b
      end

      def link_for(path, attributes = {})
        a  = new_node(:a, attributes)
        a['href'] = path
        a.content = path.split(File::SEPARATOR).last
        a
      end

      def summary(data, attributes)
        s = new_node(:div, attributes)
        s << summary_p(data, 'totals')
        s << summary_p(data, 'duration')
        s
      end

      def summary_p(data, which)
        p  = new_node(:p, which)
        p.inner_html = data.send("#{which}_inner_html")
        p
      end

      def inline_css(style_sheet)
        style = new_node('style', 'type' => 'text/css')
        file = File.expand_path("#{File.dirname(__FILE__)}/#{style_sheet}")
        style.content = "\n#{File.read(file)}"
        style
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

