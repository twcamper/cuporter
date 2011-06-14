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

    def self.new_html(view, link_assets, copy_public_assets)
      Nokogiri::XML::Document.send(:include, Cuporter::Document::Html)
      doc =  Nokogiri::XML::Document.new
      doc.view = view
      doc.link_assets = link_assets
      doc.assets_src = File.expand_path( "public", File.dirname(__FILE__) + "../../../")
      doc.assets_base_path = doc.assets_src

      # we count on the dirs being created by the option parser
      if Cuporter.output_file && copy_public_assets
        assets_target = File.dirname(Cuporter.options[:output_file]) + "/cuporter_public"
        FileUtils.rm_rf(assets_target) if File.exists?(assets_target)

        FileUtils.mkdir(assets_target)
        FileUtils.cp_r("#{doc.assets_src}/.", assets_target)
        doc.assets_base_path = "cuporter_public"
      end
      root = Nokogiri::XML::Node.new('html', doc)
      root.create_internal_subset( 'html', "-//W3C//DTD XHTML 1.0 Strict//EN", "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd")
      doc << root
      doc
    end

  end
end
