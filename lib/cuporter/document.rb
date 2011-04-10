# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Document
    def self.new_doc(format)
      doc = case format
      when /^(xml|pretty|text|csv)$/i
        new_xml
      when /^html$/i
        new_html
      end
      doc.format = format
      doc
    end

    def self.new_xml
      doc =  Nokogiri::XML::Document.new
      doc << Nokogiri::XML::Node.new('xml', doc)
      doc
    end

  end
end
