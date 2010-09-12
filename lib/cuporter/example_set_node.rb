# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  class ExampleSetNode < TagListNode

    def sort!
      # no op
    end

    def add_child(node)
      node.numerable = false unless has_children? #first row ( arg list header)
      super(node)
    end

  end
end
