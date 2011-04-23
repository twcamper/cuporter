# Copyright 2011 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Node

    module Totalling
      def total
        t = search("*[@number]").size
        self["total"] = t.to_s if t > 0
        children.each {|child| child.total }
      end
    end

  end
end
