# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Document
    def self.new_doc(format, view)
      doc = new_xml
      doc.view = view
      doc.format = format
      doc
    end

    def self.new_xml
      doc =  Nokogiri::XML::Document.new
      doc << Nokogiri::XML::Node.new('xml', doc)
      doc.root << Nokogiri::XML::Node.new('body', doc)
      doc
    end

  end
end
