require 'rubygems'
require 'rake/testtask'
require 'rspec/core/rake_task'

task :default do
  Rake.application.tasks_in_scope(["cuporter:test"]).each do |t|
    t.invoke
  end
end

namespace :cuporter do

  # $ rake cuporter:run["-f html cucumber_tag_report.html"]
  desc "run cuporter command line with options"
  task :run, [:options] do |t, args|
    sh "ruby ./bin/cuporter.rb #{args.options}"
  end

  namespace :test do
    desc "unit specs"
    RSpec::Core::RakeTask.new(:unit) do |t|
      t.pattern = "spec/cuporter/*_spec.rb"
      t.spec_opts = ["--color" , "--format" , "doc" ]
    end

    desc "functional specs against feature fixtures"
    RSpec::Core::RakeTask.new(:functional) do |t|
      t.pattern = "spec/cuporter/functional/**/*_spec.rb"
      t.spec_opts = ["--color" , "--format" , "doc" ]
    end

    desc "cucumber features"
    task :cucumber do
      sh "cucumber"
    end
  end
end
