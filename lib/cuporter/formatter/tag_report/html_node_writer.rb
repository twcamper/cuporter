# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License

module Cuporter
  module Formatter
    module TagReport
      class HtmlNodeWriter < Cuporter::Formatter::HtmlNodeWriter

        def write_nodes(report)
          report.report_node.children.each do |tag_node|
            tag_node.number_all_descendants
            write_node(tag_node)
          end
          builder
        end

      end
    end
  end
end
