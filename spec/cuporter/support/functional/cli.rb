module Spec
  module Functional
    module Cli
      def one_feature(path)
        `bin#{File::SEPARATOR}cuporter --input-file #{path}`
      end

      def one_feature_name_report(path)
        `bin#{File::SEPARATOR}cuporter -r name --input-file #{path}`
      end
    end
  end
end

