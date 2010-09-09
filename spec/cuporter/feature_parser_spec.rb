require 'spec_helper'

module Cuporter
  describe FeatureParser do
    context "#tags" do
      context "one tag" do
        it "returns one tag" do
          feature = FeatureParser.parse("@wip\nFeature: foo")
          feature.tags.should == ["@wip"]
        end
      end

      context "two tags on one line" do
        it "returns two tags" do
          feature = FeatureParser.parse(" \n@smoke @wip\nFeature: foo")
          feature.tags.sort.should == %w[@smoke @wip].sort
        end
      end
      context "two tags on two lines" do
        it "returns two tags" do
          feature = FeatureParser.parse(" \n@smoke\n @wip\nFeature: foo")
          feature.tags.sort.should == %w[@smoke @wip].sort
        end
      end
      context "no tags" do
        it "returns no tags" do
          feature = FeatureParser.parse("\nFeature: foo")
          feature.tags.should == []
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

    context "#parse" do
      context "table which is not an example set" do
        it "does not raise an error" do
          content = <<EOF

Feature: table not examples

    Scenario: no examples under here
      Given foo
      When bar
      Then wow:
        | All       |
        | Some      |
        | Any       |
        | Few       |
        | Most      |
EOF

          expect do
            FeatureParser.parse(content)
          end.to_not raise_error
        end
      end
    end

  end
end

