require 'spec_helper'

module Cuporter

  describe "Tag Reports of Scenario Outlines in Single Features" do

    context "scenario outline with 2 examples" do
      context "1 example tag" do
        it "returns 1 tag mapped to 1 example" do
          report = one_feature( "fixtures/scenario_outline_with_2_examples/1_example_tag.feature")
          report.should  == <<EOF
  @smoke
    Feature: foo
      Scenario Outline: outline
        Scenarios: bang
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
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
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
  @wip
    Feature: foo
      Scenario Outline: some
        Scenarios: another
          |foo|bar|fan|
          | 7 | 8 | 9 |
          | 0 | 1 | 2 |
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
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
  @taggy
    Feature: foo
      Scenario Outline: outline
        Scenarios: another
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
        Scenarios: yet
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
  @waggy
    Feature: foo
      Scenario Outline: outline
        Scenarios: another
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
        Scenarios: yet
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
  @wip
    Feature: foo
      Scenario Outline: outline
        Scenarios: another
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
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
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
        Scenarios: yet
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
  @smoke
    Feature: foo
      Scenario Outline: outline
        Scenarios: yet
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
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
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
        Scenarios: yet
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
  @smoke
    Feature: foo
      Scenario Outline: outline
        Scenarios: yet
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
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
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
        Scenarios: yet
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
  @s_o_tag
    Feature: foo
      Scenario Outline: outline
        Scenarios: another
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
        Scenarios: yet
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
  @smoke
    Feature: foo
      Scenario Outline: outline
        Scenarios: yet
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
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
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
        Scenarios: yet
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
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
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
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
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
  @f_tag
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

      context "1 feature tag, 2 scenario tags, 1 outline tag, 1 example tag" do
        it "returns 5 tags" do
          report = one_feature( "fixtures/1_scenario_and_1_outline_with_2_examples/1_feature_tag_2_scenario_tags_1_outline_tag_1_example_tag.feature")
          report.should  == <<EOF
  @e_tag
    Feature: foo
      Scenario Outline: outline
        Scenarios: yet
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
  @f_tag
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
  @o_tag
    Feature: foo
      Scenario Outline: outline
        Scenarios: another
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
        Scenarios: yet
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
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
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
  @s_o_tag_1
    Feature: foo
      Scenario Outline: outline 1
        Scenarios: example
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
  @s_o_tag_2
    Feature: foo
      Scenario Outline: outline 2
        Scenarios: another
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
        Scenarios: yet
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
  @wip
    Feature: foo
      Scenario: oh
EOF
        end
      end

      context "2 outline tags, 2 example tags, 2 empty example names" do
        it "returns 4 tags" do
          report = one_feature( "fixtures/2_outlines_1_scenario/empty_example_name.feature")
          report.should  == <<EOF
  @e_tag
    Feature: foo
      Scenario Outline: outline 2
        Examples:
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
  @nameless
    Feature: foo
      Scenario Outline: outline 1
        Scenarios:
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
  @s_o_tag_1
    Feature: foo
      Scenario Outline: outline 1
        Scenarios:
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
        Scenarios: example set 2
          |foo|bar|fan|
          | 5 | 6 | 7 |
          | 8 | 9 | 0 |
  @s_o_tag_2
    Feature: foo
      Scenario Outline: outline 2
        Examples:
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
        Examples: another
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
          report = one_feature( "fixtures/3_scenario_outlines.feature")
          report.should  == <<EOF
  @blocked
    Feature: foo
      Scenario Outline: outline 2
        Scenarios: another
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
  @e_tag
    Feature: foo
      Scenario Outline: outline 3
        Scenarios: yet
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
  @s_o_tag_1
    Feature: foo
      Scenario Outline: outline 1
        Scenarios: example
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
  @s_o_tag_3
    Feature: foo
      Scenario Outline: outline 3
        Scenarios: another
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
        Scenarios: yet
          |foo|bar|fan|
          | 1 | 2 | 3 |
          | 4 | 5 | 6 |
  @wip
    Feature: foo
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

  end
end

