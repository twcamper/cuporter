require 'rubygems'
require 'rspec'

describe Object do

  def nokogiri_instance_methods
    Nokogiri::XML::Node.instance_methods.reject {|m| m =~ /taguri|yaml/ }.sort
  end

  def nokogiri_singleton_methods
    Nokogiri::XML::Node.singleton_methods.reject {|m| m =~ /taguri|yaml/ }.sort
  end
  describe "loading cuporter files without running it does not change Nokogiri" do
    it "requiring cuporter does not alter Nokogiri::XML::Node" do
      gem "nokogiri"

      load('nokogiri.rb').should be_true
      instance_methods_before = nokogiri_instance_methods
      singletons_before = nokogiri_singleton_methods
      instance_methods_before.should_not include("cuke_name")

      load('cuporter.rb').should be_true
      instance_methods_after = nokogiri_instance_methods
      singletons_after = nokogiri_singleton_methods

      instance_methods_before.should == instance_methods_after
      singletons_before.should == singletons_after
      instance_methods_after.should_not include("cuke_name")
    end

    it "requiring cuporter does not alter Nokogiri::XML::Document" do
      gem "nokogiri"
      load('nokogiri.rb').should be_true
      instance_methods_before = nokogiri_instance_methods
      singletons_before = nokogiri_singleton_methods

      instance_methods_before.should_not include("add_filter_summary")
      load('cuporter.rb').should be_true
      instance_methods_after = nokogiri_instance_methods
      singletons_after = nokogiri_singleton_methods

      instance_methods_before.should == instance_methods_after
      singletons_before.should == singletons_after

      instance_methods_after.should_not include("add_filter_summary")
    
    end

  end
end
