require 'spec_helper'

module Cuporter
  describe FeatureParser do
    let(:file)  {"file.feature"}
    context "#tags" do
      context "one tag" do
        it "returns one tag" do
          File.should_receive(:read).with(file).and_return("@wip\nFeature: foo")
          feature = FeatureParser.tag_list(file)
          feature.tags.should == ["@wip"]
        end
      end

      context "two tags on one line" do
        it "returns two tags" do
          File.should_receive(:read).with(file).and_return(" \n@smoke @wip\nFeature: foo")
          feature = FeatureParser.tag_list(file)
          feature.tags.sort.should == %w[@smoke @wip].sort
        end
      end
      context "two tags on two lines" do
        it "returns two tags" do
          File.should_receive(:read).with(file).and_return(" \n@smoke\n @wip\nFeature: foo")
          feature = FeatureParser.tag_list(file)
          feature.tags.sort.should == %w[@smoke @wip].sort
        end
      end
      context "no tags" do
        it "returns no tags" do
          File.should_receive(:read).with(file).and_return("\nFeature: foo")
          feature = FeatureParser.tag_list(file)
          feature.tags.should == []
        end
      end

    end

    context "#name" do
      let(:name) {"Feature: consume a fairly typical feature name, and barf it back up"}
      context "sentence with comma" do
        it "returns the full name" do
          File.should_receive(:read).with(file).and_return("\n#{name}\n  Background: blah")
          feature = FeatureParser.tag_list(file)
          feature.name.should == name
        end
      end
      context "name followed by comment" do
        it "returns only the full name" do
          File.should_receive(:read).with(file).and_return("# Here is a feature comment\n# And another comment\n #{name} # comment text here\n  Background: blah")
          feature = FeatureParser.tag_list(file)
          feature.name.should == name
        end
      end

    end

    context "table which is not an example set" do
      before do
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

        File.should_receive(:read).with(file).and_return(content)
      end

      context "#parse" do
        it "does not raise an error" do
          expect do
            feature = FeatureParser.tag_list(file)
          end.to_not raise_error
        end
      end

      context "#parse_names" do
        it "does not raise an error" do
          expect do
            feature = FeatureParser.name_list(file, Filter.new)
          end.to_not raise_error
        end
      end
    end

    context "#parse_names" do
      context "one scenario" do
        it "returns a feature name and scenario name" do
          content = <<EOF
Feature: just one scenario

  Scenario: the scenario in question
    Given foo
    When bar
    Then wow
    And gee
EOF
          File.should_receive(:read).with(file).and_return(content)
          feature = FeatureParser.name_list(file, Filter.new)
          feature.should be_a Node
          feature.file.should == file
          feature.name.should == "Feature: just one scenario"
          feature.should have_children
          feature.children.first.name.should == "Scenario: the scenario in question"
        end
      end
    end

  end
end

