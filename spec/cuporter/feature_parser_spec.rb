require 'spec_helper'

module Cuporter
  describe FeatureParser do
    let(:file)  {"file.feature"}
    let(:doc)   {Cuporter::Document.new_xml}

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

      context "#tag_nodes" do
        it "does not raise an error" do
          expect do
            feature = FeatureParser.tag_nodes(file, doc, Filter.new, '.')
          end.to_not raise_error
        end
      end

      context "#node" do
        it "does not raise an error" do
          expect do
            feature = FeatureParser.node(file, doc, Filter.new, '.')
          end.to_not raise_error
        end
      end
    end

  end
end

