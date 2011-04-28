# Copyright 2010 ThoughtWorks, Inc. Licensed under the MIT License
module StringExtensions
  def to_class_name
    gsub(/(^|_)([a-zA-Z])/) {$2.upcase}
  end

  APOSTROPHE = "\047"
  APOS_ENTITY = "&apos;"
  def escape_apostrophe
    gsub(APOSTROPHE, APOS_ENTITY)
  end

  def unescape_apostrophe
    gsub(APOS_ENTITY, APOSTROPHE)
  end
end

class String
  include(StringExtensions)
end
