# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  class Filter

    attr_reader :include, :exclude

    def initialize(tags = {})
    end

    def pass?(tags)
      true
    end
  end
end
