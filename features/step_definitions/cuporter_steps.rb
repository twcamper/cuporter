When /^I run cuporter (.*)$/ do |cuporter_opts|
  @output = `bin#{File::SEPARATOR}cuporter #{cuporter_opts}`
end

Then /^.* should have the same contents as "([^"]*)"$/ do |expected_file|
  @output.should == IO.read(File.expand_path(expected_file))
end

Given /^output directory "([^"]*)"$/ do |path|
  @output_dir = path
  FileUtils.mkdir_p(@output_dir) unless File.exist?(@output_dir) and File.directory?(@output_dir)
end

Then /^the head element should not have "([^"]*)" tags$/ do |tag_name|
  result = doc.search("head #{tag_name}")
  result.should be_empty
end

Then /^the head element should have "([^"]*)" tags of type "([^"]*)"$/ do |tag_name, type_value|
  result = doc.search("head #{tag_name}[@type='#{type_value}']")
  result.should_not be_empty
end

Then /^the head element should have "([^"]*)" tags of type "([^"]*)" whose "([^\"]+)" exists$/ do |tag_name, type_value, file_attr|
  result = doc.search("head #{tag_name}[@type='#{type_value}']")
  result.should_not be_empty
  result.each do |e|
    File.exist?(e[file_attr.to_sym]).should be_true
  end
end

Then /^the head element should have "([^"]*)" tags of type "([^"]*)" whose "([^\"]+)" begins "([^\"]+)"$/ do |tag_name, type_value, file_attr, base_path_substring|
  result = doc.search("head #{tag_name}[@type='#{type_value}']")
  result.should_not be_empty
  result.each do |e|
    e[file_attr.to_sym].should =~ /^#{Regexp.escape(base_path_substring)}/
  end
end

Then /^the head element should have "([^"]*)" tags of type "([^"]*)" with no "([^"]*)" attribute$/ do |tag_name, type_value, black_attr|
  result = doc.search("head #{tag_name}[@type='#{type_value}']")
  actual_count = result.select { |e| e[black_attr.to_sym].nil? }.size
  actual_count.should > 0
end

Then /^dir "([^"]*)" should exist$/ do |path|
  File.exist?(path).should be_true
end

Then /^"([^"]*)" files should exist$/ do |glob_pattern|
  asset_files = Dir[glob_pattern]
  asset_files.should_not be_empty
  asset_files.each do |f|
    File.exist?(f).should be_true
  end
end

Then /^the head element should have "([^"]*)" tags of type "([^"]*)" whose "([^"]*)" is relative$/ do |tag_name, type_value, file_attr|
  result = doc.search("head #{tag_name}[@type='#{type_value}']")
  result.should_not be_empty
  result.each do |e|
    File.exist?(e[file_attr.to_sym]).should be_true
  end
end

When /I read file "([^\"]+)"$/ do |path|
  @output = File.read(path)
end

Then /^file "([^"]*)" should not exist$/ do |file_path|
  File.exist?(file_path).should be_false
end

Then /^file "([^"]*)" should exist$/ do |file_path|
  File.exist?(file_path).should be_true
  @output = File.read(file_path).strip
end

Then /^it should have "([^"]*)" nodes$/ do |css|
  our_nodes = Nokogiri.HTML(@output).search(css)
  our_nodes.should_not be_empty
end

Then /^(?:it|the output) should end with "([^\"]+)"$/ do |expected_tail|
  @output.should =~ /#{expected_tail}$/
end

