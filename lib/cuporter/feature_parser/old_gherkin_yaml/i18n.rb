require 'yaml'

module Gherkin
  class I18n

    LANGUAGES            = YAML.load_file(File.dirname(__FILE__) + '/i18n.yml')

  end
end
