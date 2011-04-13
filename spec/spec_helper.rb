require 'rubygems'
require 'rspec'
require 'cuporter'
Dir["spec/cuporter/support/**/*.rb"].each { |lib| require lib }

RSpec.configure do |config|
  config.include(Spec::Functional::Cli)
end

