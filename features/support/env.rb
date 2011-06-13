$LOAD_PATH << File.expand_path('../../../lib' , __FILE__)
require 'cuporter'

module Support
  def doc
    @doc ||= Nokogiri::HTML(File.open(@output_file_path))
  end
end

World(Support)

