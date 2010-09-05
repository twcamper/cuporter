require 'spec_helper'

module Cuporter
  describe NodeNumberer do
    context '#number' do
      let(:root) {Node.new("root")} 
      let(:numberer) { NodeNumberer.new}

      before(:each) do
        root.add_child(Node.new("child_1"))
        root.add_child(Node.new("child_2"))
      end

      it 'does not add number to root node' do
        numberer.number(root)

        root.number.should be_nil
      end

      it 'adds a number to both children' do
       numberer.number(root)

        root[:child_1].number.should == 1
        root[:child_2].number.should == 2
      end

      it 'does not add a number to children with children' do
        root[:child_1].add_child(Node.new("grandbaby"))

        numberer.number(root)

        root[:child_1].number.should be_nil
        root[:child_2].number.should == 1
      end

      it 'numbers child and grandchild in same sequence' do
        root[:child_1].add_child(Node.new("grandbaby"))

        numberer.number(root)

        root[:child_2].number.should             == 1
        root[:child_1][:grandbaby].number.should == 2
      end

      context '2 children, 1 grandchild, and 2 great-grandchildren' do
        before(:each) do
          root[:child_2].add_child(Node.new("grandbaby"))
          root.add_child(Node.new(:child_3))
          child_4 = Node.new(:child_4)
          child_4.add_child(Node.new(:grandchild))
          child_4[:grandchild].add_child(Node.new(:great_grandchild_1))
          child_4[:grandchild].add_child(Node.new(:great_grandchild_2))
          root.add_child(child_4)
        end

        it 'numbers the leaf nodes' do
          numberer.number(root)

          root.number.should be_nil
          root[:child_1].number.should == 1
          root[:child_2].number.should be_nil
          root[:child_3].number.should == 2
          root[:child_4].number.should be_nil

          root[:child_2][:grandbaby].number.should == 3
          root[:child_4][:grandchild].number.should be_nil
          root[:child_4][:grandchild][:great_grandchild_1].number.should == 4
          root[:child_4][:grandchild][:great_grandchild_2].number.should == 5
        end

        it 'keeps total' do
          numberer.total.should == 0
          numberer.number(root)
          numberer.total.should == 5
        end
      end
    end

  end
end
