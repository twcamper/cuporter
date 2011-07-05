require 'rubygems'
require 'rspec'
require 'cuporter'
require 'config/configuration'
Dir["spec/cuporter/support/**/*.rb"].each { |lib| require lib }

ENV['CUPORTER_MODE'] = 'test'

RSpec.configure do |config|  
  config.include(Spec::Functional::Cli)
end

