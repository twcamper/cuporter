# Copyright 2011 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Node

    module Sorting
      include Comparable

      def sort_all_descendants!
        sort!
        children.each {|child| child.sort_all_descendants! }
      end

      # see #NodeSetExtensions in extensions/nokogiri.rb
      def sort!
        return unless has_children?
        sorted_children = children.sort
        self.children = sorted_children
      end

      def <=>(other)
        (short_cuke_name || name) <=> (other.short_cuke_name || other.name)
      end

    end

  end
end
