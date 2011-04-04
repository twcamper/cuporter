# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Node
    class ExampleSet < Tagged
      def sort!
        # no op
      end

      def add_child(other)
        unless has_children? #first row ( arg list header)
          other.delete("number")
        end
        super(other)
      end

    end
  end
end
