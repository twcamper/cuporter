require 'spec_helper'

module Cuporter
  describe TagReport do
    context "#scenarios_per_tag" do
      context "empty input" do
        it "should not raise an error" do
          tag_report = TagReport.new("fixtures/empty_file.feature")
          expect do
            @report = tag_report.scenarios_per_tag
          end.to_not raise_error
        end
      end
    end
  end
end
