# Copyright 2011 ThoughtWorks, Inc. Licensed under the MIT License

module Cuporter
  module FeatureParser
    class TagNodesParser < ParserBase

      # ++sub_expression++ is the paren group in the regex, dereferenced with $1 in the caller
      def new_feature_node(sub_expression, file)
        {:cuke_name => sub_expression, :tags => @current_tags, :file_path => file}
      end

      def handle_scenario_line(sub_expression)
        if @filter.pass?(@feature[:tags] | @current_tags)
          s = {:cuke_name => sub_expression, :tags => @current_tags}

          (@feature[:tags] | s[:tags]).each do |tag|
            next unless @filter.pass?([tag])
            add_scenario(tag, @feature, s)
          end
        end
      end

      def new_scenario_outline_node(sub_expression)
        {:cuke_name => sub_expression, :tags => @current_tags}
      end

      def handle_example_set_line
      end

      def new_example_set_node(sub_expression)
        {:cuke_name => sub_expression.to_s.strip, :tags => @current_tags}
      end

      def new_example_line(sub_expression)
        context_tags = (@feature[:tags] | @scenario_outline[:tags] | @example_set[:tags])
        if @filter.pass?(context_tags)
          e = {:cuke_name => sub_expression}

          context_tags.each do |tag|
            next unless @filter.pass?([tag])
            add_example(tag, @feature, @scenario_outline, @example_set, e)
          end
        end
      end


      def handle_eof
        # EOF is the final way that we know we are finished with a "Scenario Outline"
        close_scenario_outline
        handle_tagless_feature if @filter.empty?
      end

      def handle_tagless_feature
        if @feature && !@report.feature_node(@feature)
          unless ( t = @report.tag_node('@TAGLESS'))
            t = @report.add_child(Node.new_node(:tag, @doc, 'cuke_name' => '@TAGLESS'))
          end
          t.add_child(Node.new_node(:Feature, @doc, @feature))
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
      def add_scenario(tag, feature, scenario)
        unless ( t = @report.tag_node(tag))
          t = @report.add_child(Node.new_node(:tag, @doc, 'cuke_name' => tag))
        end
        unless ( f = t.feature_node(feature) )
          f = t.add_child(Node.new_node(:Feature, @doc, feature))
        end
        f.add_child(Node.new_node(:Scenario, @doc, scenario))
      end

      def add_example(tag, feature, scenario_outline, example_set, example)
        unless ( t = @report.tag_node(tag))
          t = @report.add_child(Node.new_node(:Tag, @doc, 'cuke_name' => tag))
        end
        unless ( f = t.feature_node(feature) )
          f = t.add_child(Node.new_node(:Feature, @doc, feature))
        end
        unless ( so = f.scenario_outline_node(scenario_outline) )
          so = f.add_child(Node.new_node(:ScenarioOutline, @doc, scenario_outline))
        end

        # The first Example is an ExampleHeader, which does not get counted or
        # numbered.  If the ExampleSet is new, it has no children, and therefore
        # this is the first and should be an ExampleHeader.
        example_type = :Example
        unless ( es = so.example_set_node(example_set) )
          es = so.add_child(Node.new_node(:Examples, @doc, example_set))
          example_type = :ExampleHeader
        end
        es.add_child(Node.new_node(example_type, @doc, example))
      end


      def initialize(file, report, filter)
        super(file)
        @filter = filter
        @report = report
        @doc = report.document
      end

    end
  end
end
