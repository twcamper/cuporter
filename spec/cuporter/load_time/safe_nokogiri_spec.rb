require 'rubygems'
require 'rspec'

describe Object do
  describe "loading cuporter files without running it does not change Nokogiri" do
    it "requiring cuporter does not alter Nokogiri::XML::Node" do
      gem "nokogiri", ">= 1.0.0"

      load('nokogiri.rb').should be_true
      instance_methods_before = Nokogiri::XML::Node.instance_methods.sort
      singletons_before = Nokogiri::XML::Node.singleton_methods.sort
      instance_methods_before.should_not include("cuke_name")

      load('cuporter.rb').should be_true
      instance_methods_after = Nokogiri::XML::Node.instance_methods.sort
      singletons_after = Nokogiri::XML::Node.singleton_methods.sort

      instance_methods_before.should == instance_methods_after
      singletons_before.should == singletons_after
      instance_methods_after.should_not include("cuke_name")
    end

    it "requiring cuporter does not alter Nokogiri::XML::Document" do
      gem "nokogiri", ">= 1.0.0"
      load('nokogiri.rb').should be_true
      instance_methods_before = Nokogiri::XML::Document.instance_methods.sort
      singletons_before = Nokogiri::XML::Document.singleton_methods.sort

      instance_methods_before.should_not include("add_filter_summary")
      load('cuporter.rb').should be_true
      instance_methods_after = Nokogiri::XML::Document.instance_methods.sort
      singletons_after = Nokogiri::XML::Document.singleton_methods.sort

      instance_methods_before.should == instance_methods_after
      singletons_before.should == singletons_after

      instance_methods_after.should_not include("add_filter_summary")
    
    end

  end
end
