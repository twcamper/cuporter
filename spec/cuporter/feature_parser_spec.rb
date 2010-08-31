require 'spec_helper'

module Cuporter
  describe FeatureParser do
    context "#universal_tags" do
      context "one tag" do
        it "returns one tag" do
          feature = FeatureParser.parse("@wip\nFeature: foo")
          feature.universal_tags.should == ["@wip"]
        end
      end

      context "two tags on one line" do
        it "returns two tags" do
          feature = FeatureParser.parse(" \n@smoke @wip\nFeature: foo")
          feature.universal_tags.sort.should == %w[@smoke @wip].sort
        end
      end
      context "two tags on two lines" do
        it "returns two tags" do
          feature = FeatureParser.parse(" \n@smoke\n @wip\nFeature: foo")
          feature.universal_tags.sort.should == %w[@smoke @wip].sort
        end
      end
      context "no tags" do
        it "returns no tags" do
          feature = FeatureParser.parse("\nFeature: foo")
          feature.universal_tags.should == []
        end
      end

    end

    context "#name" do
      let(:name) {"Feature: consume a fairly typical feature name, and barf it back up"}
      context "sentence with comma" do
        it "returns the full name" do
          feature = FeatureParser.parse("\n#{name}\n  Background: blah")
          feature.name.should == name
        end
      end
      context "name followed by comment" do
        it "returns only the full name" do
          feature = FeatureParser.parse("# Here is a feature comment\n# And another comment\n #{name} # comment text here\n  Background: blah")
          feature.name.should == name
        end
      end

    end

  end
end

