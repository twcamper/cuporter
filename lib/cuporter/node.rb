# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
require 'rubygems'
require 'nokogiri'
require 'forwardable'
require 'lib/cuporter/node/base'
require 'lib/cuporter/node/tagged_node'

Dir["lib/cuporter/node/*.rb"].each do |lib|
  require lib
end
