require 'spec_helper'

module Cuporter::Config::CLI
  describe FilterArgsBuilder do
    context "maps command line args to hash args" do
      context "empty command line args" do
        it "returns empty hash" do
          builder = FilterArgsBuilder.new([])
          builder.args.should be_empty
        end
      end

      context "no command line args" do
        it "returns empty hash" do
          builder = FilterArgsBuilder.new()
          builder.args.should be_empty
        end
      end

      context "just a NOT tag" do
        it "returns a hash with one item" do
          builder = FilterArgsBuilder.new(["~@wip"])
          builder.args.should == {:none => ["@wip"]}
        end
      end

      context "more than one NOT, AND, and OR" do
        it "return hash with :none, :all, and :any" do
          cli_args = ["~@one", "@two,@three", "@four", "~@five", "~@six", "@seven,@eight,@nine", "@ten"]
          builder = FilterArgsBuilder.new(cli_args)
          builder.args.should == {:none => ["@one", "@five", "@six"],
            :all  => ["@four", "@ten"],
            :any  => ["@two", "@three", "@seven", "@eight", "@nine"]}
        end
      end

    end
  end
end
