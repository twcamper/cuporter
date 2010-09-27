require 'spec_helper'

module Cuporter
  describe TagReport do
    context "#report_node" do
      context "empty input" do
        it "should not raise an error" do
          tag_report = TagReport.new("fixtures/empty_file.feature", number_scenarios = false)
          expect do
            @report = tag_report.report_node
          end.to_not raise_error
        end
      end
    end
  end
  
  describe NameReport do
    context "#report_node" do
      context "empty input" do
        it "should not raise an error" do
          name_report = NameReport.new("fixtures/empty_file.feature", number_scenarios = false)
          expect do
            @report = name_report.report_node
          end.to_not raise_error
        end
      end
    end
  end
end
