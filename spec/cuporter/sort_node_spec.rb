require 'spec_helper'

module Cuporter
  describe Node do
    context 'sorting' do
      it 'defaults to order of addition' do
        root = Node.new('root')
        root.add_child(Node.new('zebra'))
        root.add_child(Node.new('aardvark'))

        root.names.should == %w[zebra aardvark]
      end

      it 'sorts direct descendants' do
        root = Node.new('root')
        root.add_child(Node.new('zebra'))
        root.add_child(Node.new('aardvark'))

        root.sort_all_descendants!
        root.names.should == %w[aardvark zebra]
      end

      it 'sorts all descendants to an arbitrary depth, such as 6' do
        root = Node.new('root')
        zebra  = Node.new("zebra")
        apple  = Node.new("apple")
        zebra1 = Node.new("zebra1")
        apple1 = Node.new("apple1")
        zebra2 = Node.new("zebra2")
        apple2 = Node.new("apple2")
        zebra3 = Node.new("zebra3")
        apple3 = Node.new("apple3")
        zebra4 = Node.new("zebra4")
        apple4 = Node.new("apple4")
        zebra5 = Node.new("zebra5")
        apple5 = Node.new("apple5")
        
        zebra4.add_child(zebra5)
        zebra4.add_child(apple5)
        apple4.add_child(zebra5)
        apple4.add_child(apple5)

        zebra3.add_child(zebra4)
        zebra3.add_child(apple4)
        apple3.add_child(zebra4)
        apple3.add_child(apple4)

        zebra2.add_child(zebra3)
        zebra2.add_child(apple3)
        apple2.add_child(zebra3)
        apple2.add_child(apple3)

        zebra1.add_child(zebra2)
        zebra1.add_child(apple2)
        apple1.add_child(zebra2)
        apple1.add_child(apple2)

        zebra.add_child(zebra1)
        zebra.add_child(apple1)
        apple.add_child(zebra1)
        apple.add_child(apple1)

        root.add_child(zebra)
        root.add_child(apple)

        root.sort_all_descendants!
        root.names.should == %w[apple zebra]
        gen_1 = %w[apple1 zebra1]
        root[:apple].names.should == gen_1
        root[:zebra].names.should == gen_1

        gen_2 = %w[apple2 zebra2]
        root[:apple][:apple1].names.should == gen_2
        root[:apple][:zebra1].names.should == gen_2
        root[:zebra][:apple1].names.should == gen_2
        root[:zebra][:zebra1].names.should == gen_2

        gen_3 = %w[apple3 zebra3]
        root[:apple][:apple1][:apple2].names.should == gen_3
        root[:apple][:apple1][:zebra2].names.should == gen_3
        root[:apple][:zebra1][:apple2].names.should == gen_3
        root[:apple][:zebra1][:zebra2].names.should == gen_3
        root[:zebra][:apple1][:apple2].names.should == gen_3
        root[:zebra][:apple1][:zebra2].names.should == gen_3
        root[:zebra][:zebra1][:apple2].names.should == gen_3
        root[:zebra][:zebra1][:zebra2].names.should == gen_3

        gen_4 = %w[apple4 zebra4]
        root[:apple][:apple1][:apple2][:apple3].names.should == gen_4
        root[:apple][:apple1][:apple2][:zebra3].names.should == gen_4
        root[:apple][:apple1][:zebra2][:apple3].names.should == gen_4
        root[:apple][:apple1][:zebra2][:zebra3].names.should == gen_4

        root[:apple][:zebra1][:apple2][:apple3].names.should == gen_4
        root[:apple][:zebra1][:apple2][:zebra3].names.should == gen_4
        root[:apple][:zebra1][:zebra2][:apple3].names.should == gen_4
        root[:apple][:zebra1][:zebra2][:zebra3].names.should == gen_4

        root[:zebra][:apple1][:apple2][:apple3].names.should == gen_4
        root[:zebra][:apple1][:apple2][:zebra3].names.should == gen_4
        root[:zebra][:apple1][:zebra2][:apple3].names.should == gen_4
        root[:zebra][:apple1][:zebra2][:zebra3].names.should == gen_4

        root[:zebra][:zebra1][:apple2][:apple3].names.should == gen_4
        root[:zebra][:zebra1][:apple2][:zebra3].names.should == gen_4
        root[:zebra][:zebra1][:zebra2][:apple3].names.should == gen_4
        root[:zebra][:zebra1][:zebra2][:zebra3].names.should == gen_4

        gen_5 = %w[apple5 zebra5]
        root[:apple][:apple1][:apple2][:apple3][:apple4].names.should == gen_5
        root[:apple][:apple1][:apple2][:apple3][:zebra4].names.should == gen_5
        root[:apple][:apple1][:apple2][:apple3][:apple4].names.should == gen_5
        root[:apple][:apple1][:apple2][:apple3][:zebra4].names.should == gen_5
        root[:apple][:apple1][:apple2][:zebra3][:apple4].names.should == gen_5
        root[:apple][:apple1][:apple2][:zebra3][:zebra4].names.should == gen_5
        root[:apple][:apple1][:apple2][:zebra3][:apple4].names.should == gen_5
        root[:apple][:apple1][:apple2][:zebra3][:zebra4].names.should == gen_5

        root[:apple][:apple1][:zebra2][:apple3][:apple4].names.should == gen_5
        root[:apple][:apple1][:zebra2][:apple3][:zebra4].names.should == gen_5
        root[:apple][:apple1][:zebra2][:apple3][:apple4].names.should == gen_5
        root[:apple][:apple1][:zebra2][:apple3][:zebra4].names.should == gen_5
        root[:apple][:apple1][:zebra2][:zebra3][:apple4].names.should == gen_5
        root[:apple][:apple1][:zebra2][:zebra3][:zebra4].names.should == gen_5
        root[:apple][:apple1][:zebra2][:zebra3][:apple4].names.should == gen_5
        root[:apple][:apple1][:zebra2][:zebra3][:zebra4].names.should == gen_5

        root[:apple][:zebra1][:apple2][:apple3][:apple4].names.should == gen_5
        root[:apple][:zebra1][:apple2][:apple3][:zebra4].names.should == gen_5
        root[:apple][:zebra1][:apple2][:apple3][:apple4].names.should == gen_5
        root[:apple][:zebra1][:apple2][:apple3][:zebra4].names.should == gen_5
        root[:apple][:zebra1][:apple2][:zebra3][:apple4].names.should == gen_5
        root[:apple][:zebra1][:apple2][:zebra3][:zebra4].names.should == gen_5
        root[:apple][:zebra1][:apple2][:zebra3][:apple4].names.should == gen_5
        root[:apple][:zebra1][:apple2][:zebra3][:zebra4].names.should == gen_5

        root[:apple][:zebra1][:zebra2][:apple3][:apple4].names.should == gen_5
        root[:apple][:zebra1][:zebra2][:apple3][:zebra4].names.should == gen_5
        root[:apple][:zebra1][:zebra2][:apple3][:apple4].names.should == gen_5
        root[:apple][:zebra1][:zebra2][:apple3][:zebra4].names.should == gen_5
        root[:apple][:zebra1][:zebra2][:zebra3][:apple4].names.should == gen_5
        root[:apple][:zebra1][:zebra2][:zebra3][:zebra4].names.should == gen_5
        root[:apple][:zebra1][:zebra2][:zebra3][:apple4].names.should == gen_5
        root[:apple][:zebra1][:zebra2][:zebra3][:zebra4].names.should == gen_5


        root[:zebra][:apple1][:apple2][:apple3][:apple4].names.should == gen_5
        root[:zebra][:apple1][:apple2][:apple3][:zebra4].names.should == gen_5
        root[:zebra][:apple1][:apple2][:apple3][:apple4].names.should == gen_5
        root[:zebra][:apple1][:apple2][:apple3][:zebra4].names.should == gen_5
        root[:zebra][:apple1][:apple2][:zebra3][:apple4].names.should == gen_5
        root[:zebra][:apple1][:apple2][:zebra3][:zebra4].names.should == gen_5
        root[:zebra][:apple1][:apple2][:zebra3][:apple4].names.should == gen_5
        root[:zebra][:apple1][:apple2][:zebra3][:zebra4].names.should == gen_5

        root[:zebra][:apple1][:zebra2][:apple3][:apple4].names.should == gen_5
        root[:zebra][:apple1][:zebra2][:apple3][:zebra4].names.should == gen_5
        root[:zebra][:apple1][:zebra2][:apple3][:apple4].names.should == gen_5
        root[:zebra][:apple1][:zebra2][:apple3][:zebra4].names.should == gen_5
        root[:zebra][:apple1][:zebra2][:zebra3][:apple4].names.should == gen_5
        root[:zebra][:apple1][:zebra2][:zebra3][:zebra4].names.should == gen_5
        root[:zebra][:apple1][:zebra2][:zebra3][:apple4].names.should == gen_5
        root[:zebra][:apple1][:zebra2][:zebra3][:zebra4].names.should == gen_5

        root[:zebra][:zebra1][:apple2][:apple3][:apple4].names.should == gen_5
        root[:zebra][:zebra1][:apple2][:apple3][:zebra4].names.should == gen_5
        root[:zebra][:zebra1][:apple2][:apple3][:apple4].names.should == gen_5
        root[:zebra][:zebra1][:apple2][:apple3][:zebra4].names.should == gen_5
        root[:zebra][:zebra1][:apple2][:zebra3][:apple4].names.should == gen_5
        root[:zebra][:zebra1][:apple2][:zebra3][:zebra4].names.should == gen_5
        root[:zebra][:zebra1][:apple2][:zebra3][:apple4].names.should == gen_5
        root[:zebra][:zebra1][:apple2][:zebra3][:zebra4].names.should == gen_5

        root[:zebra][:zebra1][:zebra2][:apple3][:apple4].names.should == gen_5
        root[:zebra][:zebra1][:zebra2][:apple3][:zebra4].names.should == gen_5
        root[:zebra][:zebra1][:zebra2][:apple3][:apple4].names.should == gen_5
        root[:zebra][:zebra1][:zebra2][:apple3][:zebra4].names.should == gen_5
        root[:zebra][:zebra1][:zebra2][:zebra3][:apple4].names.should == gen_5
        root[:zebra][:zebra1][:zebra2][:zebra3][:zebra4].names.should == gen_5
        root[:zebra][:zebra1][:zebra2][:zebra3][:apple4].names.should == gen_5
        root[:zebra][:zebra1][:zebra2][:zebra3][:zebra4].names.should == gen_5

      end

    end
  end
end
