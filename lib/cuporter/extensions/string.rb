# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module StringExtensions
  def to_class_name
    gsub(/(^|_)([a-zA-Z])/) {$2.upcase}
  end
end

class String
  include(StringExtensions)
end
