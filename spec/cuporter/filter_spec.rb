require 'spec_helper'

module Cuporter
  describe Filter do
    context "#empty?" do
      context "empty" do
        it "returns true" do
          Filter.new.should be_empty
        end
      end

      context "not empty" do
        it "returns false if :all not empty" do
          Filter.new(:all => :foo).should_not be_empty
        end
        it "returns false if :any not empty" do
          Filter.new(:any => :foo).should_not be_empty
        end
        it "returns false if :none not empty" do
          Filter.new(:none => :foo).should_not be_empty
        end
      end
    end

    context "#pass?" do
      let(:tag_list)  { %w[@one @two @three] }
      context "empty filter" do
        context "no init args" do
          it "raises no error" do
            expect do
              Filter.new
            end.to_not raise_error()
          end

          it "all tag lists are empty" do
            filter = Filter.new
            filter.all.should be_empty
            filter.any.should be_empty
            filter.none.should be_empty
          end
        end

        it "passes" do
          Filter.new.pass?(tag_list).should be_true
        end
      end

      context "empty tag list" do 
        it "passes with empty filter" do
          Filter.new().pass?([]).should be_true
        end
        it "passes with none list" do
          Filter.new(:none => :@foo).pass?([]).should be_true
        end

        it "fails with any list" do
          Filter.new(:any => :@foo).pass?([]).should be_false
        end
        it "fails with all list" do
          Filter.new(:all => :@foo).pass?([]).should be_false
        end
      end

      context "filter has tags" do 
        context "any: logical OR" do
          it "fails with no match" do
            Filter.new(:any => :@four).pass?(tag_list) 
          end
          it "passes with one match" do
            Filter.new(:any => :@two).pass?(tag_list) 
          end
          it "passes with two matches" do
            Filter.new(:any => [:@one, :@three]).pass?(tag_list)
          end
        end

        context "all: logical AND" do
          it "passes when 1 of 3 matches" do
            Filter.new(:all => %w[@one]).pass?(tag_list)
          end
          it "passes when 2 of 3 match" do
            Filter.new(:all => %w[@one @two]).pass?(tag_list)
          end
          it "passes when 3 of 3 match" do
            Filter.new(:all => %w[@one @two @three]).pass?(tag_list)
          end
          it "fails with only a non-match" do
            Filter.new(:all => %w[@four]).pass?(tag_list)
          end
          it "fails with a match and a non-match" do
            Filter.new(:all => %w[@one @four]).pass?(tag_list)
          end
        end

        context "none: logical NOT" do
          it "passes with only a non-match" do
            Filter.new(:none => %w[@four]).pass?(tag_list)
          end
          it "fails with a match and a non-match" do
            Filter.new(:none => %w[@two @four]).pass?(tag_list)
          end
          it "fails with a match" do
            Filter.new(:none => %w[@two]).pass?(tag_list)
          end
        end

        context "any and none" do
          it "passes with a match on 'any' and a non-match on 'none'" do
            Filter.new(:any => %w[@one], :none => %w[@four]).pass?(tag_list)
          end
          it "fails with a match on 'any' and a match on 'none'" do
            Filter.new(:any => %w[@one], :none => %w[@three]).pass?(tag_list)
          end
          it "fails with a non-match on 'any' and match on 'none'" do
            Filter.new(:any => %w[@four], :none => %w[@two]).pass?(tag_list) 
          end
        end

        context "all and none" do
          it "passes with a match on 'all' and a non-match on 'none'" do
            Filter.new(:all => %w[@one], :none => %w[@four]).pass?(tag_list)
          end
          it "fails with a match and a non-match on 'all' and a non-match on 'none'" do
            Filter.new(:all => %w[@one @four], :none => %w[@five]).pass?(tag_list)
          end
          it "fails with all matches on 'all' and a match on 'none'" do
            Filter.new(:all => %w[@one], :none => %w[@two]).pass?(tag_list)
          end
        end
      end
    end
  end
end
