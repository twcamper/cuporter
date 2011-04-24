require 'spec_helper'

module Cuporter

  describe "Name Reports of Scenario Outlines in Single Features" do

    context "1 scenario and 1 outline with 2 examples" do
      context "1 scenario tag, 1 outline tag" do
        it "returns 2 tags, 1 with a scenario, 1 with an outline" do
          report = one_feature_name_report( "fixtures/1_scenario_and_1_outline_with_2_examples/1_scenario_tag_1_outline_tag.feature")
          report.should  == <<EOF
  Feature: foo
    Scenario: oh
    Scenario Outline: outline
      Scenarios: another
        |foo|bar|fan|
        | 1 | 2 | 3 |
        | 4 | 5 | 6 |
      Scenarios: yet
        |foo|bar|fan|
        | 1 | 2 | 3 |
        | 4 | 5 | 6 |
EOF
        end
      end

    end

    context "2 outlines 1 scenario" do
      context "2 outline tags, 1 scenario tag, 1 example tag" do
        it "returns 4 tags" do
          report = one_feature_name_report( "fixtures/2_outlines_1_scenario/2_outline_tags_1_scenario_tag_1_example_tag.feature")
          report.should  == <<EOF
  Feature: foo
    Scenario: oh
    Scenario Outline: outline 1
      Scenarios: example
        |foo|bar|fan|
        | 1 | 2 | 3 |
        | 4 | 5 | 6 |
    Scenario Outline: outline 2
      Scenarios: another
        |foo|bar|fan|
        | 1 | 2 | 3 |
        | 4 | 5 | 6 |
      Scenarios: yet
        |foo|bar|fan|
        | 1 | 2 | 3 |
        | 4 | 5 | 6 |
EOF
        end
      end

    end

    context "scenario outlines only" do
      context "3 outlines" do
        it "includes all outlines" do
          report = one_feature_name_report( "fixtures/3_scenario_outlines.feature")
          report.should  == <<EOF
  Feature: foo
    Scenario Outline: outline 1
      Scenarios: example
        |foo|bar|fan|
        | 1 | 2 | 3 |
        | 4 | 5 | 6 |
    Scenario Outline: outline 2
      Scenarios: another
        |foo|bar|fan|
        | 1 | 2 | 3 |
        | 4 | 5 | 6 |
      Scenarios: yet
        |foo|bar|fan|
        | 1 | 2 | 3 |
        | 4 | 5 | 6 |
    Scenario Outline: outline 3
      Scenarios: another
        |foo|bar|fan|
        | 1 | 2 | 3 |
        | 4 | 5 | 6 |
      Scenarios: yet
        |foo|bar|fan|
        | 1 | 2 | 3 |
        | 4 | 5 | 6 |
EOF
        end
      end

    end

  end
end

