require 'spec_helper'

module Cuporter
  describe TagReport do
    context "#report_node" do
      context "empty input" do
        it "should not raise an error" do
          tag_report = TagReport.new(:input_file_pattern => "fixtures/empty_file.feature", :filter_args => {})
          expect do
            @report = tag_report.build_report_node
          end.to_not raise_error
        end
      end
    end
  end
  
  describe FeatureReport do
    context "#report_node" do
      context "empty input" do
        it "should not raise an error" do
          name_report = FeatureReport.new(:input_file_pattern => "fixtures/empty_file.feature", :filter_args => {})
          expect do
            @report = name_report.report_node
          end.to_not raise_error
        end
      end
    end
  end
end
