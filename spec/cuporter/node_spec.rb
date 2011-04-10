require 'spec_helper'

module Cuporter
  module Node
    describe BaseNode do
      let(:doc) {Nokogiri::XML::Document.new}
      context 'new node' do
        let(:node) {BaseNode.new("name", doc)}
        it 'has a name' do
          node.name.should == "name"
          node.node_name.should == "name"
        end
        it 'has an empty list of children' do
          node.should_not have_children
        end
      end

      context 'children' do
        let(:node) {BaseNode.new("parent", doc)}
        it 'can add a child' do
          child = BaseNode.new("child", doc)
          node.add_child(child)
          node.should have_children
        end
      end

      context 'equivalence' do
        it 'eql? means value equivalence' do
          n1 = BaseNode.new('herbert', doc)
          n2 = BaseNode.new('herbert', doc)
          n1.add_child(BaseNode.new('lou', doc))
          n2.add_child(BaseNode.new('lou', doc))
          n1.should eql n2
        end

        it 'Feature node considers file value in eql?' do
          n1 = Feature.new('herbert', doc)
          n2 = Feature.new('herbert', doc)
          n1.should eql n2
          n1['file'] = "a.feature"
          n2['file'] = "b.feature"
          n1.should_not eql n2
        end
      end

      context 'totalling' do
        let(:node) {BaseNode.new('node', doc)}
        it 'should not total its non-numerable children' do
          node.add_child(BaseNode.new('child', doc))
          node.total
          node['total'].should be_nil
          node.at(:child)['total'].should be_nil
        end

        it 'can total its numerable children' do
          child = BaseNode.new('child', doc)
          child['number'] = 'true'
          node.add_child(child)
          node.total
          node['total'].should == '1'
        end
      end

      context 'numbering' do
        let(:node) {BaseNode.new('node', doc)}
        it 'can number itself' do
          expect do
            node.number_all_descendants
          end.to_not raise_error()
        end

        it 'gets a leaf count' do
          node.number_all_descendants
          node.total.should == 0
          node['total'].should be_nil
        end

        it 'should not number non-numerable descendants' do
          node.add_child(BaseNode.new('child', doc))
          node.number_all_descendants
          node.at(:child)['number'].should be_nil
        end

        it 'should number numerable descendants' do
          child = BaseNode.new('child', doc)
          child['number'] = 'true'
          grandchild = BaseNode.new('grandchild', doc)
          greatgrandchild = BaseNode.new('greatgrandchild', doc)
          greatgrandchild['number'] = 'true'
          
          grandchild.add_child(greatgrandchild)
          child.add_child(grandchild)
          node.add_child(child)

          node.number_all_descendants
          node['number'].should be_nil
          node.at(:child)['number'].should == '1'
          node.at(:grandchild)['number'].should be_nil
          node.at(:greatgrandchild)['number'].should == '2'
        end

      end

    end
  end
end
