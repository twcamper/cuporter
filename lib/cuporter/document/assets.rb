# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module Cuporter
  module Document
    module Assets
      PUBLIC_SOURCE_PATH = File.expand_path( "public", File.dirname(__FILE__) + "../../../../")
      RELATIVE_PUBLIC_ASSETS_PATH = "cuporter_public"

      def self.copy(output_file_path)
        assets_target = "#{File.dirname(output_file_path)}/#{RELATIVE_PUBLIC_ASSETS_PATH}"
        FileUtils.rm_rf(assets_target) if File.exists?(assets_target)
        FileUtils.mkdir(assets_target)
        FileUtils.cp_r("#{PUBLIC_SOURCE_PATH}/.", assets_target)
      end

      def self.base_path(use_copied_public_assets)
        # we count on the dirs being created by the option parser
        if use_copied_public_assets
          RELATIVE_PUBLIC_ASSETS_PATH
        else
          PUBLIC_SOURCE_PATH
        end
      end
    end
  end
end
