require 'spec_helper'

module Cuporter
  describe FeatureParser do
    let(:file)  {"file.feature"}

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

      context "#tag_list" do
        it "does not raise an error" do
          expect do
            feature = FeatureParser.tag_list(file)
          end.to_not raise_error
        end
      end

      context "#name_list" do
        it "does not raise an error" do
          expect do
            feature = FeatureParser.name_list(file, Filter.new)
          end.to_not raise_error
        end
      end
    end

  end
end

