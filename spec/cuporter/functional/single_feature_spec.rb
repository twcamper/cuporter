require 'spec_helper'

module Cuporter

  describe "Single Feature Tag Reports" do

    context "one scenario one tag" do
      it "returns one tag mapped to one scenario name" do
        report = one_feature( "fixtures/one_scenario_one_tag.feature")
        report.should == <<EOF
@wip
  Feature: foo
    Scenario: bar the great foo
EOF
      end
    end

    context "one scenario two tags" do
      it "returns two tags mapped to the same scenario" do
        report = one_feature( "fixtures/one_scenario_two_tags.feature")
        report.should  == <<EOF
@smoke
  Feature: foo
    Scenario: some test of something
@wip
  Feature: foo
    Scenario: some test of something
EOF
      end
    end

    context "two scenarios one tag" do
      it "returns one tag mapped to one scenario" do
        report = one_feature( "fixtures/two_scenarios_one_tag.feature")
        report.should == <<EOF
@smoke
  Feature: foo
    Scenario: another test
EOF
      end
    end

    context "one scenario tag one feature tag" do
      it "returns two tags, one mapped to one scenario, the other mapped to two" do
          report = one_feature( "fixtures/one_scenario_tag_one_feature_tag.feature")
          report.should  == <<EOF
@customer_module
  Feature: foo
    Scenario: another test
    Scenario: some test of something
@smoke
  Feature: foo
    Scenario: another test
EOF
      end
    end


    context "scenario outline with 2 examples" do
      context "1 example tag" do
        it "returns 1 tag mapped to 1 example" do
          report = one_feature( "fixtures/scenario_outline_with_2_examples/1_example_tag.feature")
          report.should  == <<EOF
@smoke
  Feature: foo
    Scenario Outline: outline
      Scenarios: bang
EOF
        end
      end

      context "1 tag per example" do
        it "returns 2 examples mapped to a tag" do
          report = one_feature( "fixtures/scenario_outline_with_2_examples/1_tag_per_example.feature")
          report.should  == <<EOF
@smoke
  Feature: foo
    Scenario Outline: some
      Scenarios: yet
@wip
  Feature: foo
    Scenario Outline: some
      Scenarios: another
EOF
        end
      end

      context "1 tag per example, 2 feature tags" do
        it "returns 4 tags . . ." do
          report = one_feature( "fixtures/scenario_outline_with_2_examples/1_tag_per_example_2_feature_tags.feature")
          report.should  == <<EOF
@smoke
  Feature: foo
    Scenario Outline: outline
      Scenarios: yet
@taggy
  Feature: foo
    Scenario Outline: outline
      Scenarios: another
      Scenarios: yet
@waggy
  Feature: foo
    Scenario Outline: outline
      Scenarios: another
      Scenarios: yet
@wip
  Feature: foo
    Scenario Outline: outline
      Scenarios: another
EOF
        end
      end

      context "1 example tag and 1 feature tag" do
        it "returns 2 tags" do
          report = one_feature( "fixtures/scenario_outline_with_2_examples/1_example_tag_and_1_feature_tag.feature")
          report.should  == <<EOF
@f_tag
  Feature: foo
    Scenario Outline: outline
      Scenarios: another
      Scenarios: yet
@smoke
  Feature: foo
    Scenario Outline: outline
      Scenarios: yet
EOF
        end
      end

      context "1 example tag and 1 scenario outline tag" do
        it "returns 1 example mapped to 1 tag" do
          report = one_feature( "fixtures/scenario_outline_with_2_examples/1_example_tag_and_1_scenario_outline_tag.feature")
          report.should  == <<EOF
@s_o_tag
  Feature: foo
    Scenario Outline: outline
      Scenarios: another
      Scenarios: yet
@smoke
  Feature: foo
    Scenario Outline: outline
      Scenarios: yet
EOF
        end
      end
      context "1 example tag, 1 scenario outline tag, 1 feature tag" do
        it "3 tags" do
          report = one_feature( "fixtures/scenario_outline_with_2_examples/1_example_tag_1_scenario_outline_tag_1_feature_tag.feature")
          report.should  == <<EOF
@f_tag
  Feature: foo
    Scenario Outline: outline
      Scenarios: another
      Scenarios: yet
@s_o_tag
  Feature: foo
    Scenario Outline: outline
      Scenarios: another
      Scenarios: yet
@smoke
  Feature: foo
    Scenario Outline: outline
      Scenarios: yet
EOF
        end
      end
    end

    context "1 scenario and 1 outline with 2 examples" do
      context "1 scenario tag, 1 outline tag" do
        it "returns 2 tags, 1 with a scenario, 1 with an outline" do
          report = one_feature( "fixtures/1_scenario_and_1_outline_with_2_examples/1_scenario_tag_1_outline_tag.feature")
          report.should  == <<EOF
@s_o_tag
  Feature: foo
    Scenario Outline: outline
      Scenarios: another
      Scenarios: yet
@s_tag
  Feature: foo
    Scenario: oh
EOF
        end
      end

      context "1 scenario tag, 1 example tag" do
        it "returns 2 tags, 1 with a scenario and 1 with an outline" do
          report = one_feature( "fixtures/1_scenario_and_1_outline_with_2_examples/1_scenario_tag_1_example_tag.feature")
          report.should  == <<EOF
@s_o_tag
  Feature: foo
    Scenario Outline: outline
      Scenarios: another
@s_tag
  Feature: foo
    Scenario: oh
EOF
        end
      end

      context "1 feature tag, 1 example tag" do
        it "returns 2 tags" do
          report = one_feature( "fixtures/1_scenario_and_1_outline_with_2_examples/1_feature_tag_1_example_tag.feature")
          report.should  == <<EOF
@example_tag
  Feature: foo
    Scenario Outline: outline
      Scenarios: another
@f_tag
  Feature: foo
    Scenario: oh
    Scenario Outline: outline
      Scenarios: another
      Scenarios: yet
EOF

        end
      end

      context "1 feature tag, 2 scenario tags, 1 outline tag, 1 example tag" do
        it "returns 5 tags" do
          report = one_feature( "fixtures/1_scenario_and_1_outline_with_2_examples/1_feature_tag_2_scenario_tags_1_outline_tag_1_example_tag.feature")
          report.should  == <<EOF
@e_tag
  Feature: foo
    Scenario Outline: outline
      Scenarios: yet
@f_tag
  Feature: foo
    Scenario: oh
    Scenario Outline: outline
      Scenarios: another
      Scenarios: yet
@o_tag
  Feature: foo
    Scenario Outline: outline
      Scenarios: another
      Scenarios: yet
@s_tag
  Feature: foo
    Scenario: oh
@wip
  Feature: foo
    Scenario: oh
EOF
        end
      end

    end

    context "2 outlines 1 scenario" do
      context "2 outline tags, 1 scenario tag, 1 example tag" do
        it "returns 4 tags" do
          report = one_feature( "fixtures/2_outlines_1_scenario/2_outline_tags_1_scenario_tag_1_example_tag.feature")
          report.should  == <<EOF
@e_tag
  Feature: foo
    Scenario Outline: outline 2
      Scenarios: yet
@s_o_tag_1
  Feature: foo
    Scenario Outline: outline 1
      Scenarios: example
@s_o_tag_2
  Feature: foo
    Scenario Outline: outline 2
      Scenarios: another
      Scenarios: yet
@wip
  Feature: foo
    Scenario: oh
EOF
        end
      end
    end

  end
end

