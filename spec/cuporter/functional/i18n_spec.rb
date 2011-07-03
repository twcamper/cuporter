require 'spec_helper'

module Cuporter
  describe 'Internationalization' do
    let(:file)  {"file.feature"}
    let(:doc)   {Cuporter::Document.new_xml}

    context "Specify an iso-code in a language header" do

      context "en" do
        before do
          content = <<EOF
# language: en
@english
Feature: fern nottingham zulu wing molding

    @customer
    Scenario: examples under here
      Given foo
      When bar
      Then wow I guess it is true
EOF

          File.should_receive(:read).with(file).and_return(content)
        end
        it "does not raise an error" do
          expect do
            begin
            feature = FeatureParser.node(file, doc, Filter.new, '.')
            rescue Exception => ex
              puts ex.backtrace
              raise ex
            end
            end.to_not raise_error
        end
      end

      context "no" do

        it "returns a Norwegian tag report" do
          report = one_feature("fixtures/i18n/no.feature")
          report.should == <<EOF
  @i18n
    Egenskap: Summering
      Scenario: to tall
      Scenario: tre tall
  @wip
    Egenskap: Summering
      Scenario: tre tall
EOF
        end
      end
    end

  end
end

