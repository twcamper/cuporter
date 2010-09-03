When /^I run cuporter (.*)$/ do |cuporter_opts|
  @output = `bin#{File::SEPARATOR}cuporter #{cuporter_opts}`
end


Then /^.* should have the same contents as "([^"]*)"$/ do |expected_file|
  @output.should == IO.read(File.expand_path(expected_file))
end
