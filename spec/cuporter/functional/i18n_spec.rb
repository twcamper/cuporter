require 'spec_helper'

module Cuporter
  describe 'Internationalization' do
    let(:file)  {"file.feature"}
    let(:doc)   {Cuporter::Document.new_xml}

    context "installed gherkin" do
      it "language line pattern matches all iso codes from gherkin" do
        require 'gherkin/i18n'
        installed_iso_codes = Gherkin::I18n::LANGUAGES.keys
        installed_iso_codes.each do |iso_code|
          Cuporter::FeatureParser::Language::LANGUAGE_LINE.should =~ "# language: #{iso_code}"
        end
      end
    end
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
              FeatureParser.node(file, doc, Filter.new, '.')
            end.to_not raise_error
        end
      end

      context "no" do

        it "returns a Norwegian tag report" do
          report = one_feature("fixtures/i18n/no.feature")
          report.should == <<EOF
  @i18n
    Egenskap: Summering
      Abstrakt Scenario: eep oop ap
        Eksempler:  wee wee wee
          | oop | nerf |
          | nnn | mmm  |
          | lok | frey |
          | drf | mmm  |
      Scenario: to tall
      Scenario: tre tall
  @troll
    Egenskap: Summering
      Abstrakt Scenario: eep oop ap
        Eksempler:  wee wee wee
          | oop | nerf |
          | nnn | mmm  |
          | lok | frey |
          | drf | mmm  |
  @wip
    Egenskap: Summering
      Scenario: tre tall
EOF
        end
      end
    end

  end
end

