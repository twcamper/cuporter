require 'spec_helper'

module Cuporter
  describe Node do
    context 'new node' do
      let(:node) {Node.new("name")}
      it 'has a name' do
        node.name.should == "name"
      end
      it 'has an empty list of children' do
        node.should_not have_children
      end
    end

    context 'children' do
      let(:node) {Node.new("parent")}
      it 'can add a child' do
        child = Node.new("child")
        node.add_child(child)
        node.should have_children
      end

      it 'does not check child type' do
        expect {
          node.add_child(:foo)
        }.to_not raise_error()
      end

      it 'does not add duplicate' do
        child = Node.new('child')
        child.add_child Node.new('grandchild')
        twin = child.dup

        child.should == twin
        child.object_id.should_not == twin.object_id

        node.add_child child
        node.children.size.should == 1

        node.add_child twin
        node.children.size.should == 1
      end
    end

    context 'equivalence' do
      it '== means value equivalence' do
        n1 = Node.new('herbert')
        n2 = Node.new('herbert')
        n1.add_child(Node.new('lou'))
        n2.add_child(Node.new('lou'))
        n1.should == n2
      end
    end
  end
end
