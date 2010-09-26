# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License

module Cuporter
  module CLI
    class FilterArgsBuilder
      def initialize(cli_tags)
        @cli_tags = cli_tags
        @all  = []
        @any  = []
        @none = []
        @args = {}
        filter_args
      end

      def filter_args
        @cli_tags.each do |expression|
          case expression
          when /^~@/
            @none << expression.sub(/~/,'')
          when /,/
            @any |= expression.split(',')
          else
            @all << expression
          end
        end
      end

      def args
        @args[:any]  = @any unless @any.empty?
        @args[:all]  = @all unless @all.empty?
        @args[:none] = @none unless @none.empty?
        @args
      end

    end
  end
end
