# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  class NonSortingNode < Node
    attr_reader :tags

    def initialize(name, tags)
      super(name)
      @tags = tags
    end

    def sort
      self
    end

  end
end
