module Spec
  module Functional
    module Cli
      def one_feature(path)
        `bin#{File::SEPARATOR}cuporter.rb --input-file #{path}`
      end
    end
  end
end

