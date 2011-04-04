# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  class XmlReport < Report
    def doc
      @doc ||= new_doc
    end

    def xml
      doc.root << body
      p doc.class
      doc.to_xml(:indent => 2, :encoding => 'UTF-8')
    end

    private

    def report_node
      report = new_node("report")
      files.each do |file|
        feature = FeatureParser.node(file, @doc, @filter)
        if feature && feature.has_children?
          report << feature
        end
      end
      report.number_all_descendants
      report.total
      report
    end

    def body
      b = new_node(:body)
      b << report_node
      b
    end

    def new_doc
      doc = Nokogiri::XML::Document.new
      doc << Nokogiri::XML::Node.new(root_path, doc)
      doc
    end
    
    def new_node(name, attributes = {})
      n = Nokogiri::XML::Node.new(name.to_s, @doc)
      attributes.each do | attr, value |
        n[attr.to_s] = value.to_s
      end
      n
    end

  end
end
