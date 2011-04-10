module Spec
  module Functional
    module Cli
      def one_feature(path)
        `bin#{File::SEPARATOR}cuporter --file-input #{path}`
      end

      def one_feature_name_report(path)
        `bin#{File::SEPARATOR}cuporter -r feature --file-input #{path}`
      end

      def any_report(options)
        `bin#{File::SEPARATOR}cuporter #{options}`
      end
    end
  end
end

