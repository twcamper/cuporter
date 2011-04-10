require 'spec_helper'

module Cuporter
  module Node
    describe Tagged do
      context 'new tag list node' do
        let(:tag_list_node) {Tagged.new("name", []) }
        it 'is a node' do
          tag_list_node.should be_a Node
        end

        it 'has an empty tag list' do
          tag_list_node.should_not have_tags
        end
        context 'with tags' do
          it 'should have tags' do
            tag_list_node = Tagged.new("name", %w[tag_1 tag_2])
            tag_list_node.should have_tags
          end
        end
      end

      context 'children' do
        context 'with universal tags but none of their own' do
          it 'child inherits one tag from parent' do
            tag_list_node = Tagged.new("parent", ["p_tag_1"])
            tag_list_node.add_to_tag_nodes(Tagged.new("child", []))

            tag_list_node.children.size.should == 1
            tag_list_node.children.first.name.should == "p_tag_1"

            tag_list_node[:p_tag_1].children.size.should == 1
            tag_list_node[:p_tag_1].children.first.name.should == "child"

          end
          it 'child inherits 2 tags from parent' do
            tag_list_node = Tagged.new("parent", ["p_tag_1", "p_tag_2"])
            tag_list_node.add_to_tag_nodes(Tagged.new("child", []))

            tag_list_node.children.size.should == 2
            tag_list_node.children.first.name.should == "p_tag_1"
            tag_list_node.children.last.name.should  == "p_tag_2"

            tag_list_node[:p_tag_1].children.size.should == 1
            tag_list_node[:p_tag_1].children.first.name.should == "child"

            tag_list_node[:p_tag_2].children.size.should == 1
            tag_list_node[:p_tag_2].children.first.name.should == "child"

          end
        end
        context 'without universal tags but some of their own' do
          let(:tag_list_node) {Tagged.new("parent", []) }
          it 'child has one tag' do
            tag_list_node.add_to_tag_nodes(Tagged.new("child", ["c_tag_1"]))

            tag_list_node.children.size.should == 1
            tag_list_node.children.first.name.should == "c_tag_1"

            tag_list_node[:c_tag_1].children.size.should == 1
            tag_list_node[:c_tag_1].children.first.name.should == "child"
          end
          it 'child has two tags' do
            tag_list_node.add_to_tag_nodes(Tagged.new("child", ["c_tag_1", "c_tag_2"]))

            tag_list_node.children.size.should == 2
            tag_list_node.children.first.name.should == "c_tag_1"
            tag_list_node.children.last.name.should  == "c_tag_2"

            tag_list_node[:c_tag_1].children.size.should == 1
            tag_list_node[:c_tag_1].children.first.name.should == "child"

            tag_list_node[:c_tag_2].children.size.should == 1
            tag_list_node[:c_tag_2].children.first.name.should == "child"
          end
        end
        context 'with universal tags and their own tags' do
          let(:tag_list_node) {Tagged.new("parent",%w[p_tag_1 p_tag_2]) }
          it "2 universal tags and 2 child tags" do
            tag_list_node.add_to_tag_nodes(Tagged.new("child", ["c_tag_1", "c_tag_2"]))

            tag_list_node.children.size.should == 4
            tag_list_node.children.collect do |c|
              c.name
            end.should == %w[p_tag_1 p_tag_2 c_tag_1 c_tag_2]

            tag_list_node[:p_tag_1].children.size.should == 1
            tag_list_node[:p_tag_1].children.first.name.should == "child"

            tag_list_node[:p_tag_2].children.size.should == 1
            tag_list_node[:p_tag_2].children.first.name.should == "child"

            tag_list_node[:c_tag_1].children.size.should == 1
            tag_list_node[:c_tag_1].children.first.name.should == "child"

            tag_list_node[:c_tag_2].children.size.should == 1
            tag_list_node[:c_tag_2].children.first.name.should == "child"
          end
        end
        context 'with no tags at all' do
          it 'top node has no children' do
            tag_list_node = Tagged.new("parent", [])
            tag_list_node.add_to_tag_nodes(Tagged.new("child", []))

            tag_list_node.should_not have_children

          end

        end

        context 'second child with preexisting tag' do
          it 'top node has 1 child and 2 grandchildren' do
            tag_list_node = Tagged.new("parent", ["p_tag_1"])
            tag_list_node.add_to_tag_nodes(Tagged.new("child_1", []))
            tag_list_node.add_to_tag_nodes(Tagged.new("child_2", []))

            tag_list_node.children.size.should == 1
            tag_list_node.children[0].name.should == "p_tag_1"

            tag_list_node[:p_tag_1].children.size.should == 2
            tag_list_node[:p_tag_1].children[0].name.should == "child_1"
            tag_list_node[:p_tag_1].children[1].name.should == "child_2"
          end

          it '2 child nodes with 1 universal tag and 2 child tags' do
            tag_list_node = Tagged.new("parent", ["p_tag_1"])
            tag_list_node.add_to_tag_nodes(Tagged.new("child_1", ["c_tag_1"]))
            tag_list_node.add_to_tag_nodes(Tagged.new("child_2", ["c_tag_1", "c_tag_2"]))

            tag_list_node.children.size.should == 3
            tag_list_node.children[0].name.should == "p_tag_1"
            tag_list_node.children[1].name.should == "c_tag_1"
            tag_list_node.children[2].name.should == "c_tag_2"

            tag_list_node[:p_tag_1].children.size.should == 2
            tag_list_node[:p_tag_1].children[0].name.should == "child_1"
            tag_list_node[:p_tag_1].children[1].name.should == "child_2"

            tag_list_node[:c_tag_1].children.size.should == 2
            tag_list_node[:c_tag_1].children[0].name.should == "child_1"
            tag_list_node[:c_tag_1].children[1].name.should == "child_2"

            tag_list_node[:c_tag_2].children.size.should == 1
            tag_list_node[:c_tag_2].children[0].name.should == "child_2"
          end
        end

        context '#merge_tag_nodes: child is tag list node' do
          context '1 universal tag on parent and no universal tags on child' do
            context "child must be initialized with parent's universal tags" do
              it 'top node has no children' do
                p = Tagged.new("parent", ["p_tag_1"])
                c = Tagged.new("child", [] )
                c.add_to_tag_nodes(Tagged.new("leaf_1", []))

                p.should_not have_children
              end

              it 'all leaf nodes are under parent universal tag' do
                p = Tagged.new("parent", ["p_tag_1"])
                c = Tagged.new("child", p.tags)
                c.add_to_tag_nodes(Tagged.new("leaf_1", []))
                c.add_to_tag_nodes(Tagged.new("leaf_2", []))
                p.merge_tag_nodes(c)

                p.children.size.should == 1
                p.children[0].name.should == "p_tag_1"

                p[:p_tag_1].children.size.should == 1
                p[:p_tag_1].children[0].name.should == "child"

                p[:p_tag_1][:child].children.size.should == 2
                p[:p_tag_1][:child].children[0].name.should == "leaf_1"
                p[:p_tag_1][:child].children[1].name.should == "leaf_2"

                p[:p_tag_1][:child][:leaf_1].should_not have_children
                p[:p_tag_1][:child][:leaf_2].should_not have_children
              end
            end
          end

          context '1 universal tag on parent and 1 universal tag on child' do
            it "2 tags have 2 leaf nodes" do
              p = Tagged.new("parent", ["p_tag_1"])
              c = Tagged.new("child", p.tags | ["c_tag_1"])
              c.add_to_tag_nodes(Tagged.new("leaf_1", []))
              c.add_to_tag_nodes(Tagged.new("leaf_2", []))
              p.merge_tag_nodes(c)

              p.children.size.should == 2
              p.children[0].name.should == "p_tag_1"
              p.children[1].name.should == "c_tag_1"
              p[:p_tag_1].children.size.should == 1
              p[:p_tag_1].children[0].name.should == "child"
              p[:c_tag_1].children.size.should == 1
              p[:c_tag_1].children[0].name.should == "child"

              p[:p_tag_1][:child].children.size.should == 2
              p[:p_tag_1][:child].children[0].name.should == "leaf_1"
              p[:p_tag_1][:child].children[1].name.should == "leaf_2"

              p[:c_tag_1][:child].children.size.should == 2
              p[:c_tag_1][:child].children[0].name.should == "leaf_1"
              p[:c_tag_1][:child].children[1].name.should == "leaf_2"

              p[:p_tag_1][:child][:leaf_1].should_not have_children
              p[:p_tag_1][:child][:leaf_2].should_not have_children

              p[:c_tag_1][:child][:leaf_1].should_not have_children
              p[:c_tag_1][:child][:leaf_2].should_not have_children
            end
          end

          context '1 universal tag on parent and 1 tag on 1 leaf' do
            it "1 tag has 1 leaf node, the other has 2 leaf nodes" do
              p = Tagged.new("parent", ["p_tag_1"])
              c = Tagged.new("child", p.tags )
              c.add_to_tag_nodes(Tagged.new("leaf_1", []))
              c.add_to_tag_nodes(Tagged.new("leaf_2", ["l_tag_1"]))
              p.merge_tag_nodes(c)

              p.children.size.should == 2
              p.children[0].name.should == "p_tag_1"
              p.children[1].name.should == "l_tag_1"
              p[:p_tag_1].children.size.should == 1
              p[:p_tag_1].children[0].name.should == "child"
              p[:l_tag_1].children.size.should == 1
              p[:l_tag_1].children[0].name.should == "child"

              p[:p_tag_1][:child].children.size.should == 2
              p[:p_tag_1][:child].children[0].name.should == "leaf_1"
              p[:p_tag_1][:child].children[1].name.should == "leaf_2"

              p[:l_tag_1][:child].children.size.should == 1
              p[:l_tag_1][:child].children[0].name.should == "leaf_2"

              p[:p_tag_1][:child][:leaf_1].should_not have_children
              p[:p_tag_1][:child][:leaf_2].should_not have_children

              p[:l_tag_1][:child][:leaf_2].should_not have_children
            end
          end

          context '1 universal tag on parent 1 universal tag on child 1 tag on leaf' do
            it "2 tags with 2 leaves, 1 tag with 1 leaf" do
              p = Tagged.new("parent", ["p_tag_1"])
              c = Tagged.new("child", p.tags | ["c_tag_1"])
              c.add_to_tag_nodes(Tagged.new("leaf_1", []))
              c.add_to_tag_nodes(Tagged.new("leaf_2", ["l_tag_1"]))
              p.merge_tag_nodes(c)

              p.children.size.should == 3
              p.children[0].name.should == "p_tag_1"
              p.children[1].name.should == "c_tag_1"
              p.children[2].name.should == "l_tag_1"

              p[:p_tag_1].children.size.should == 1
              p[:p_tag_1].children[0].name.should == "child"

              p[:c_tag_1].children.size.should == 1
              p[:c_tag_1].children[0].name.should == "child"

              p[:l_tag_1].children.size.should == 1
              p[:l_tag_1].children[0].name.should == "child"

              p[:p_tag_1][:child].children.size.should == 2
              p[:p_tag_1][:child].children[0].name.should == "leaf_1"
              p[:p_tag_1][:child].children[1].name.should == "leaf_2"

              p[:c_tag_1][:child].children.size.should == 2
              p[:c_tag_1][:child].children[0].name.should == "leaf_1"
              p[:c_tag_1][:child].children[1].name.should == "leaf_2"

              p[:l_tag_1][:child].children.size.should == 1
              p[:l_tag_1][:child].children[0].name.should == "leaf_2"

              p[:p_tag_1][:child][:leaf_1].should_not have_children
              p[:p_tag_1][:child][:leaf_2].should_not have_children

              p[:c_tag_1][:child][:leaf_1].should_not have_children
              p[:c_tag_1][:child][:leaf_2].should_not have_children

              p[:l_tag_1][:child][:leaf_2].should_not have_children
            end
          end
        end
      end
    end
  end
end
