# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License

module Cuporter
  class TagNodesParser < FeatureParser

    # ++sub_expression++ is the paren group in the regex, dereferenced with $1 in the caller
    def new_feature_node(sub_expression, file)
      f = Node.new_node(:Feature, @doc, :cuke_name => sub_expression, :tags => @current_tags, :file => file)
      f.filter = @filter
      f
    end

    def handle_scenario_line(sub_expression)
      s = @feature.filter_child(Node.new_node(:Scenario, @doc, :cuke_name => sub_expression, :tags => (@feature.tags | @current_tags), :number => true))

      if s
        s.tags.each do |tag|
          next unless @filter.pass? tag.to_a
          tag_node(tag).add_leaf(s, @feature)
        end
      end
    end

    def new_scenario_outline_node(sub_expression)
      so = Node.new_node(:ScenarioOutline, @doc, :cuke_name => sub_expression, :tags => (@feature.tags | @current_tags))
      so.filter = @filter
      so
    end

    def handle_example_set_line
      @scenario_outline.filter_child(@example_set)
    end

    def new_example_set_node(sub_expression)
      es = Node.new_node(:Examples, @doc, :cuke_name => sub_expression, :tags => (@scenario_outline.tags | @current_tags))
      es.filter = @filter
      es
    end

    def new_example_line(sub_expression)
      e = Node.new_node(:Example, @doc, :cuke_name => sub_expression, :number => true)
      @example_set.tags.each do |tag|
        next unless @filter.pass? tag.to_a
        tag_node(tag).add_leaf(e, @feature, @scenario_outline, @example_set)
      end
    end
    
    def tag_node(tag_name)
      attributes = {'cuke_name' => tag_name}
      unless( tn = @report.find_by('tag', attributes) )
        tn = Node.new_node(:tag, @doc, attributes)
        @report.add_child(tn)
      end
      tn
    end
    

    def initialize(file, report, filter)
      super(file)
      @filter = filter
      @report = report
      @doc    = report.document
    end

  end
end
