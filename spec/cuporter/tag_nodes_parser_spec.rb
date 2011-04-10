require 'spec_helper'

module Cuporter
  describe TagNodesParser do
    let(:file)  {"file.feature"}
    let(:doc)   {Cuporter::Document.new_xml '/'}
    let(:filter) {Cuporter::Filter.new}
    context "tags" do
      context "one tag" do
        it "returns one tag" do
          File.should_receive(:read).with(file).and_return("@wip\nFeature: foo")
          feature = TagNodesParser.new(file, doc, filter).parse_feature
          feature.tags.should == ["@wip"]
        end
      end

      context "two tags on one line" do
        it "returns two tags" do
          File.should_receive(:read).with(file).and_return(" \n@smoke @wip\nFeature: foo")
          feature = TagNodesParser.new(file, doc, filter).parse_feature
          feature.tags.sort.should == %w[@smoke @wip].sort
        end
      end
      context "two tags on two lines" do
        it "returns two tags" do
          File.should_receive(:read).with(file).and_return(" \n@smoke\n @wip\nFeature: foo")
          feature = TagNodesParser.new(file, doc, filter).parse_feature
          feature.tags.sort.should == %w[@smoke @wip].sort
        end
      end
      context "no tags" do
        it "returns no tags" do
          File.should_receive(:read).with(file).and_return("\nFeature: foo")
          feature = TagNodesParser.new(file, doc, filter).parse_feature
          feature.tags.should == []
        end
      end

    end

    context "#parse_feature" do
      let(:name) {"Feature: consume a fairly typical feature name, and barf it back up"}
      context "sentence with comma" do
        it "returns the full name" do
          File.should_receive(:read).with(file).and_return("\n#{name}\n  Background: blah")
          feature = TagNodesParser.new(file, doc, filter).parse_feature
          feature.cuke_name.should == name
        end
      end
      context "name followed by comment" do
        it "returns only the full name" do
          File.should_receive(:read).with(file).and_return("# Here is a feature comment\n# And another comment\n #{name} # comment text here\n  Background: blah")
          feature = TagNodesParser.new(file, doc, filter).parse_feature
          feature.cuke_name.should == name
        end
      end

    end

  end
end

