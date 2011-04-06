# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Node
    class Feature < Tagged

      def file
        ["file"]
      end
      
      def file_name
        file.split(/\//).last
      end

      # sort on: file path, name, substring of name after any ':'
      def <=>(other)
        if other.respond_to?(:file)
          file <=> other.file
        else
          super(other)
        end
      end

      def eql?(other)
        if other.respond_to? :file
          return false if file != other.file
        end
        super(other)
      end
    end
  end
end
