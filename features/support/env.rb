$LOAD_PATH << File.expand_path('../../../lib' , __FILE__)
require 'cuporter'
ENV['CUPORTER_MODE'] = 'test'

module Support
  def doc
    @doc ||= Nokogiri::HTML(@output)
  end
end

World(Support)

