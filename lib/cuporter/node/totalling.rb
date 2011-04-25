# Copyright 2011 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Node

    module Totalling
      def total
        total!
        children.each {|child| child.total }
      end

      def total!
        t = search("scenario,example").size
        self["total"] = t.to_s if t > 0
        nil
      end
    end

  end
end
