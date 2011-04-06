require 'spec_helper'

module Cuporter
  module Node
    describe BaseNode do
      def doc
        @doc ||= Nokogiri::XML::Document.new
      end
      def new_node(node_name)
        BaseNode.new(node_name, doc)
      end
      context 'sorting' do
        it 'defaults to order of addition' do
          root = new_node('root')
          root.add_child(new_node('zebra'))
          root.add_child(new_node('aardvark'))

          root.names.should == %w[zebra aardvark]
        end

        it 'sorts direct descendants' do
          root = new_node('root')
          root.add_child(new_node('zebra'))
          root.add_child(new_node('aardvark'))

          root.sort_all_descendants!
          root.names.should == %w[aardvark zebra]
        end

        it 'sorts on file property when it is present' do
          root = new_node('root')
          root.add_child(Cuporter::Node::Feature.new('zebra', doc))
          root.add_child(Cuporter::Node::Feature.new('aardvark', doc))

          root.find_by_name('zebra')['file']    = "features/big_files/important_thing.feature"
          root.find_by_name('aardvark')['file'] = "features/small_files/important_thing.feature"

          root.sort_all_descendants!
          root.names.should == %w[zebra aardvark]
        end

        it 'only sorts on file property when present on both self and other' do
          root = new_node('root')
          root.add_child(Cuporter::Node::Feature.new('zebra', doc))
          root.add_child(new_node('aardvark'))

          root.find_by_name('zebra')['file']    = "features/big_files/important_thing.feature"

          root.sort_all_descendants!
          root.names.should == %w[aardvark zebra]
        end
        it 'sorts all descendants to an arbitrary depth, such as 6' do
          root = new_node('root')
          zebra  = new_node("zebra")
          apple  = new_node("apple")
          zebra1 = new_node("zebra1")
          apple1 = new_node("apple1")
          zebra2 = new_node("zebra2")
          apple2 = new_node("apple2")
          zebra3 = new_node("zebra3")
          apple3 = new_node("apple3")
          zebra4 = new_node("zebra4")
          apple4 = new_node("apple4")
          zebra5 = new_node("zebra5")
          apple5 = new_node("apple5")

          zebra4.add_child(zebra5.dup)
          zebra4.add_child(apple5.dup)
          apple4.add_child(zebra5.dup)
          apple4.add_child(apple5.dup)

          zebra3.add_child(zebra4.dup)
          zebra3.add_child(apple4.dup)
          apple3.add_child(zebra4.dup)
          apple3.add_child(apple4.dup)

          zebra2.add_child(zebra3.dup)
          zebra2.add_child(apple3.dup)
          apple2.add_child(zebra3.dup)
          apple2.add_child(apple3.dup)

          zebra1.add_child(zebra2.dup)
          zebra1.add_child(apple2.dup)
          apple1.add_child(zebra2.dup)
          apple1.add_child(apple2.dup)

          zebra.add_child(zebra1.dup)
          zebra.add_child(apple1.dup)
          apple.add_child(zebra1.dup)
          apple.add_child(apple1.dup)

          root.add_child(zebra)
          root.add_child(apple)

          root.sort_all_descendants!
          root.names.should == %w[apple zebra]
          gen_1 = %w[apple1 zebra1]

          root.at('apple').names.should == gen_1
          root.at('zebra').names.should == gen_1

          gen_2 = %w[apple2 zebra2]
          root.at('apple apple1').names.should == gen_2
          root.at('apple zebra1').names.should == gen_2
          root.at('zebra apple1').names.should == gen_2
          root.at('zebra zebra1').names.should == gen_2

          gen_3 = %w[apple3 zebra3]
          root.at('apple apple1 apple2').names.should == gen_3
          root.at('apple apple1 zebra2').names.should == gen_3
          root.at('apple zebra1 apple2').names.should == gen_3
          root.at('apple zebra1 zebra2').names.should == gen_3
          root.at('zebra apple1 apple2').names.should == gen_3
          root.at('zebra apple1 zebra2').names.should == gen_3
          root.at('zebra zebra1 apple2').names.should == gen_3
          root.at('zebra zebra1 zebra2').names.should == gen_3

          gen_4 = %w[apple4 zebra4]
          root.at('apple apple1 apple2 apple3').names.should == gen_4
          root.at('apple apple1 apple2 zebra3').names.should == gen_4
          root.at('apple apple1 zebra2 apple3').names.should == gen_4
          root.at('apple apple1 zebra2 zebra3').names.should == gen_4

          root.at('apple zebra1 apple2 apple3').names.should == gen_4
          root.at('apple zebra1 apple2 zebra3').names.should == gen_4
          root.at('apple zebra1 zebra2 apple3').names.should == gen_4
          root.at('apple zebra1 zebra2 zebra3').names.should == gen_4

          root.at('zebra apple1 apple2 apple3').names.should == gen_4
          root.at('zebra apple1 apple2 zebra3').names.should == gen_4
          root.at('zebra apple1 zebra2 apple3').names.should == gen_4
          root.at('zebra apple1 zebra2 zebra3').names.should == gen_4

          root.at('zebra zebra1 apple2 apple3').names.should == gen_4
          root.at('zebra zebra1 apple2 zebra3').names.should == gen_4
          root.at('zebra zebra1 zebra2 apple3').names.should == gen_4
          root.at('zebra zebra1 zebra2 zebra3').names.should == gen_4

          gen_5 = %w[apple5 zebra5]
          root.at('apple apple1 apple2 apple3 apple4').names.should == gen_5
          root.at('apple apple1 apple2 apple3 zebra4').names.should == gen_5
          root.at('apple apple1 apple2 apple3 apple4').names.should == gen_5
          root.at('apple apple1 apple2 apple3 zebra4').names.should == gen_5
          root.at('apple apple1 apple2 zebra3 apple4').names.should == gen_5
          root.at('apple apple1 apple2 zebra3 zebra4').names.should == gen_5
          root.at('apple apple1 apple2 zebra3 apple4').names.should == gen_5
          root.at('apple apple1 apple2 zebra3 zebra4').names.should == gen_5

          root.at('apple apple1 zebra2 apple3 apple4').names.should == gen_5
          root.at('apple apple1 zebra2 apple3 zebra4').names.should == gen_5
          root.at('apple apple1 zebra2 apple3 apple4').names.should == gen_5
          root.at('apple apple1 zebra2 apple3 zebra4').names.should == gen_5
          root.at('apple apple1 zebra2 zebra3 apple4').names.should == gen_5
          root.at('apple apple1 zebra2 zebra3 zebra4').names.should == gen_5
          root.at('apple apple1 zebra2 zebra3 apple4').names.should == gen_5
          root.at('apple apple1 zebra2 zebra3 zebra4').names.should == gen_5

          root.at('apple zebra1 apple2 apple3 apple4').names.should == gen_5
          root.at('apple zebra1 apple2 apple3 zebra4').names.should == gen_5
          root.at('apple zebra1 apple2 apple3 apple4').names.should == gen_5
          root.at('apple zebra1 apple2 apple3 zebra4').names.should == gen_5
          root.at('apple zebra1 apple2 zebra3 apple4').names.should == gen_5
          root.at('apple zebra1 apple2 zebra3 zebra4').names.should == gen_5
          root.at('apple zebra1 apple2 zebra3 apple4').names.should == gen_5
          root.at('apple zebra1 apple2 zebra3 zebra4').names.should == gen_5

          root.at('apple zebra1 zebra2 apple3 apple4').names.should == gen_5
          root.at('apple zebra1 zebra2 apple3 zebra4').names.should == gen_5
          root.at('apple zebra1 zebra2 apple3 apple4').names.should == gen_5
          root.at('apple zebra1 zebra2 apple3 zebra4').names.should == gen_5
          root.at('apple zebra1 zebra2 zebra3 apple4').names.should == gen_5
          root.at('apple zebra1 zebra2 zebra3 zebra4').names.should == gen_5
          root.at('apple zebra1 zebra2 zebra3 apple4').names.should == gen_5
          root.at('apple zebra1 zebra2 zebra3 zebra4').names.should == gen_5


          root.at('zebra apple1 apple2 apple3 apple4').names.should == gen_5
          root.at('zebra apple1 apple2 apple3 zebra4').names.should == gen_5
          root.at('zebra apple1 apple2 apple3 apple4').names.should == gen_5
          root.at('zebra apple1 apple2 apple3 zebra4').names.should == gen_5
          root.at('zebra apple1 apple2 zebra3 apple4').names.should == gen_5
          root.at('zebra apple1 apple2 zebra3 zebra4').names.should == gen_5
          root.at('zebra apple1 apple2 zebra3 apple4').names.should == gen_5
          root.at('zebra apple1 apple2 zebra3 zebra4').names.should == gen_5

          root.at('zebra apple1 zebra2 apple3 apple4').names.should == gen_5
          root.at('zebra apple1 zebra2 apple3 zebra4').names.should == gen_5
          root.at('zebra apple1 zebra2 apple3 apple4').names.should == gen_5
          root.at('zebra apple1 zebra2 apple3 zebra4').names.should == gen_5
          root.at('zebra apple1 zebra2 zebra3 apple4').names.should == gen_5
          root.at('zebra apple1 zebra2 zebra3 zebra4').names.should == gen_5
          root.at('zebra apple1 zebra2 zebra3 apple4').names.should == gen_5
          root.at('zebra apple1 zebra2 zebra3 zebra4').names.should == gen_5

          root.at('zebra zebra1 apple2 apple3 apple4').names.should == gen_5
          root.at('zebra zebra1 apple2 apple3 zebra4').names.should == gen_5
          root.at('zebra zebra1 apple2 apple3 apple4').names.should == gen_5
          root.at('zebra zebra1 apple2 apple3 zebra4').names.should == gen_5
          root.at('zebra zebra1 apple2 zebra3 apple4').names.should == gen_5
          root.at('zebra zebra1 apple2 zebra3 zebra4').names.should == gen_5
          root.at('zebra zebra1 apple2 zebra3 apple4').names.should == gen_5
          root.at('zebra zebra1 apple2 zebra3 zebra4').names.should == gen_5

          root.at('zebra zebra1 zebra2 apple3 apple4').names.should == gen_5
          root.at('zebra zebra1 zebra2 apple3 zebra4').names.should == gen_5
          root.at('zebra zebra1 zebra2 apple3 apple4').names.should == gen_5
          root.at('zebra zebra1 zebra2 apple3 zebra4').names.should == gen_5
          root.at('zebra zebra1 zebra2 zebra3 apple4').names.should == gen_5
          root.at('zebra zebra1 zebra2 zebra3 zebra4').names.should == gen_5
          root.at('zebra zebra1 zebra2 zebra3 apple4').names.should == gen_5
          root.at('zebra zebra1 zebra2 zebra3 zebra4').names.should == gen_5

        end

      end
    end
  end
end
