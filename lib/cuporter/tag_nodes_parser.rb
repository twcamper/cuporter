# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License

module Cuporter
  class TagNodesParser < FeatureParser

    # ++sub_expression++ is the paren group in the regex, dereferenced with $1 in the caller
    def new_feature_node(sub_expression, file)
      {:type => :Feature, :cuke_name => sub_expression, :tags => @current_tags, :file => file}
    end

    def handle_scenario_line(sub_expression)
      if @filter.pass?(@feature[:tags] | @current_tags)
        s = {:type => :Scenario, :cuke_name => sub_expression, :tags => (@feature[:tags] | @current_tags), :number => true}

        s[:tags].each do |tag|
          next unless @filter.pass? tag.to_a
          @report.add_scenario(tag, @feature, s)
        end
      end
    end

    def new_scenario_outline_node(sub_expression)
      {:type => :ScenarioOutline, :cuke_name => sub_expression, :tags => (@feature[:tags] | @current_tags)}
    end

    def handle_example_set_line
    end

    def new_example_set_node(sub_expression)
      {:type => :Examples, :cuke_name => sub_expression.to_s.strip, :tags => (@scenario_outline[:tags] | @current_tags)}
    end

    def new_example_line(sub_expression)
      if @filter.pass?(@example_set[:tags])
        e = {:type => :Example, :cuke_name => sub_expression, :number => true}

        @example_set[:tags].each do |tag|
          next unless @filter.pass? tag.to_a
          @report.add_example(tag, @feature, @scenario_outline, @example_set, e)
        end
      end
    end

    def close_scenario_outline
      if @scenario_outline
        if @example_set
          @example_set = nil
        end
        @scenario_outline = nil
      end
    end

    def initialize(file, report, filter)
      super(file)
      @filter = filter
      @report = report
    end

  end
end
