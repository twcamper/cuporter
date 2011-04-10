require 'spec_helper'

module Cuporter

  describe "Tag report of feature files with a common feature name" do

    context "four features, one feature name, one Example Set tag" do
      it "returns four features" do
        report = any_report( "-i fixtures/ -t @e_tag")
        report.should == <<EOF
@e_tag
  Feature: foo
    Scenario Outline: outline
      Scenarios: yet
        |foo|bar|fan|
        | 1 | 2 | 3 |
        | 4 | 5 | 6 |
  Feature: foo
    Scenario Outline: outline 2
      Scenarios: yet
        |foo|bar|fan|
        | 1 | 2 | 3 |
        | 4 | 5 | 6 |
  Feature: foo
    Scenario Outline: outline 2
      Examples:
        |foo|bar|fan|
        | 1 | 2 | 3 |
        | 4 | 5 | 6 |
  Feature: foo
    Scenario Outline: outline 3
      Scenarios: yet
        |foo|bar|fan|
        | 1 | 2 | 3 |
        | 4 | 5 | 6 |
EOF
      end
    end
  end
end

