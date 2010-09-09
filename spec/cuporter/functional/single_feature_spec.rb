require 'spec_helper'

module Cuporter

  describe "Single Feature Tag Reports" do

    context "empty feature file" do
      let(:stderr_file) {"stderr.out.txt"}

      before do
        File.delete(stderr_file) if File.exist?(stderr_file)
      end

      after do
        File.delete(stderr_file) if File.exist?(stderr_file)
      end

      it "returns empty string and should not raise an error" do
        File.delete(stderr_file) if File.exist?(stderr_file)
        report = one_feature( "fixtures/empty_file.feature 2> #{stderr_file}")
        err = File.read(stderr_file)
        err.should be_empty, err
        report.should be_empty
      end
    end

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

  end
end

