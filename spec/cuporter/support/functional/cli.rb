module Spec
  module Functional
    module Cli
      def one_feature(path)
        `bin#{File::SEPARATOR}cuporter --file-input #{path} --no-total --no-number --no-show-files --no-show-tags`
      end

      def one_feature_name_report(path)
        `bin#{File::SEPARATOR}cuporter -r feature --file-input #{path} --no-total --no-number --no-show-files --no-show-tags`
      end

      def any_report(options)
        `bin#{File::SEPARATOR}cuporter #{options} --no-total --no-number --no-show-files --no-show-tags`
      end
    end
  end
end

