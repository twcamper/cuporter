require 'rubygems'
require 'rspec'
require 'cuporter'
require 'config/configuration'
Dir["spec/cuporter/support/**/*.rb"].each { |lib| require lib }

RSpec.configure do |config|
  config.include(Spec::Functional::Cli)
end

