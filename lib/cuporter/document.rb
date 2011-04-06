# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Document
    def self.new_doc(format, root_path)
      doc = case format
      when /^(xml|pretty|text|csv)$/i
        new_xml root_path
      when /^html$/i
        new_html root_path
      end
      doc.format = format
      doc
    end

    def self.new_xml(root_path)
      doc = Nokogiri::XML::Document.new
      doc << Nokogiri::XML::Node.new(root_path, doc)
      doc
    end

  end
end
module NokogiriExtensions
  attr_accessor :format
  def write
    send("to_#{format}".to_sym, :indent => 2, :encoding => 'UTF-8')
  end
end
Nokogiri::XML::Document.send(:include, NokogiriExtensions)
