# Copyright 2011 ThoughtWorks, Inc. Licensed under the MIT License
module FileExtensions

  # BOM may be included at first position by windows editors or due to
  # other file encoding related reasons.
  BOM = "\xEF\xBB\xBF"
  # codepoint: U+FEFF
  # hex:       ef bb bf
  # octal:     \357\273\277
  def without_byte_order_mark(path)
    content = read(path)
    if RUBY_VERSION =~ /^1.8/
      content.slice!(0..2) if content[0..2] == BOM
    else
      BOM.force_encoding("UTF-8")
      unless Encoding.compatible?(content, BOM)
        raise "Encoding #{content.encoding} of file '#{path}' is incompatible for comparison with #{BOM.encoding}"
      end
      content.slice!(0) if content[0] == BOM
    end
    content
  end

end

File.extend(FileExtensions)
