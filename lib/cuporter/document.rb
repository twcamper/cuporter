# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Document

    def self.new_xml
      require 'cuporter/extensions/nokogiri'
      doc =  Nokogiri::XML::Document.new
      doc << Nokogiri::XML::Node.new('xml', doc)
      doc.root << Nokogiri::XML::Node.new('body', doc)
      doc
    end

    def self.new_html(view, link_assets, assets_dir)
      Nokogiri::XML::Document.send(:include, Cuporter::Document::Html)
      doc =  Nokogiri::XML::Document.new
      doc.view = view
      doc.link_assets = link_assets
      project_assets = File.expand_path( "public", File.dirname(__FILE__) + "../../../")

      # we count on the dirs being created by the option parser
      if link_assets
        FileUtils.cp_r("#{project_assets}/.", assets_dir)
        doc.assets_dir = assets_dir
      else
        doc.assets_dir = project_assets
      end
      root = Nokogiri::XML::Node.new('html', doc)
      root.create_internal_subset( 'html', "-//W3C//DTD XHTML 1.0 Strict//EN", "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd")
      doc << root
      doc
    end

  end
end
