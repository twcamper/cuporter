# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
require 'lib/cuporter/document/html_document'
module Cuporter
  module Document
    def self.new_doc(format, view)
      doc = case format
      when /^(xml|pretty|text|csv)$/i
        new_xml
      when /^html$/i
        new_html(view)
      end
      doc.format = format
      doc
    end

    def self.new_xml
      doc =  Nokogiri::XML::Document.new
      doc << Nokogiri::XML::Node.new('xml', doc)
      doc
    end

    def self.new_html(view)
      Nokogiri::XML::Document.send(:include, Cuporter::Document::Html)
      doc =  Nokogiri::XML::Document.new
      doc.view = view
      root = Nokogiri::XML::Node.new('html', doc)
      root.create_internal_subset( 'html', "-//W3C//DTD XHTML 1.0 Strict//EN", "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd")
      doc << root
      doc
    end
  end
end
