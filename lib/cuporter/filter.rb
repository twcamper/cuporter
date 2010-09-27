# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  class Filter

    attr_reader :all, :any, :none

    def initialize(args = {})
      @all  = to_tag_array(args[:all]) # logical AND
      @any  = to_tag_array(args[:any]) # logical OR
      @none = to_tag_array(args[:none])# logical NOT
    end

    def pass?(other_tags)
      pass = true

      # Logical AND: are all of the tags in :all in the tests' tags?
      unless all.empty?
        pass = false unless (other_tags & all).size == all.size
      end

      # Logical OR: are any of the tests' tags in :any?
      unless any.empty?
        pass = false if (other_tags & any).empty?
      end

      unless none.empty?
        pass = false if !(other_tags & none).empty?
      end
      pass
    end

    def empty?
      all.empty? && any.empty? && none.empty?
    end

    private

    def to_tag_array(tag_input)
      case tag_input
      when Array
        tag_input
      when String
        tag_input.split(" ")
      when Numeric, Symbol
        [tag_input.to_s]
      else
        []
      end
    end

  end
end
