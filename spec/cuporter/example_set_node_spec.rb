require 'spec_helper'
module Cuporter
  describe ExampleSetNode do
    context 'empty' do
      it 'raises no error when numbering' do
        node = ExampleSetNode.new("Scenarios: stuff", [])
        expect do
          node.number_all_descendants
        end.to_not raise_error
        node.total.should == 0
      end
    end

    context 'with children' do
      it 'does not count first or "header" row' do
        node = ExampleSetNode.new("Scenarios: stuff", [])
        node.add_child(Node.new("|col1|col2|"))
        node.add_child(Node.new("|val1|val2|"))

        node.number_all_descendants
        node.children.first.number.should be_nil
        node.children.last.number.should == 1
      end
    end
  end
end
