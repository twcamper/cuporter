require 'rubygems'
require 'rake/testtask'
require 'rspec/core/rake_task'
require 'rake/rdoctask'
require 'rake/gempackagetask'

task :default do
  Rake::Task["cuporter:load_test:safe_nokogiri"].invoke  # MUST RUN THIS FIRST
  Rake::Task["cuporter:test:unit"].invoke
  Rake::Task["cuporter:test:functional"].invoke
  Rake::Task["cuporter:test:cucumber"].invoke
end

namespace :cuporter do

  # $ rake cuporter:run["-f html cucumber_tag_report.html"]
  desc "run cuporter command line with options"
  task :run, [:options] do |t, args|
    sh "ruby ./bin/cuporter #{args.options}"
  end

  task :readme do
    require 'redcloth'
    puts RedCloth.new(File.read("README.textile")).to_html
  end

  namespace :load_test do
    desc "RUN ME FIRST: I depend on cuporter NOT having run"
    RSpec::Core::RakeTask.new(:safe_nokogiri) do |t|
      t.pattern = "spec/cuporter/load_time/safe_nokogiri_spec.rb"
      t.rspec_opts = ["--color" , "--format" , "doc" ]
    end
  end

  namespace :test do
    desc "unit specs"
    RSpec::Core::RakeTask.new(:unit) do |t|
      t.pattern = "spec/cuporter/*_spec.rb"
      t.rspec_opts = ["--color" , "--format" , "doc" ]
    end

    desc "functional specs against feature fixtures"
    RSpec::Core::RakeTask.new(:functional) do |t|
      t.pattern = "spec/cuporter/functional/**/*_spec.rb"
      t.rspec_opts = ["--color" , "--format" , "doc" ]
    end

    desc "cucumber features"
    task :cucumber do
      sh "cucumber --quiet"
    end
  end

  RDOC_OPTS = ["--all" , "--quiet" , "--line-numbers" , "--inline-source", 
    "--main", "README.textile", 
    "--title", "Cuporter: cucumber tag reporting"]
  XTRA_RDOC = %w{bin/cuporter README.textile LICENSE }

  Rake::RDocTask.new do |rd|
    rd.rdoc_dir = "doc/rdoc"
    rd.rdoc_files.include("**/*.rb")
    rd.rdoc_files.add(XTRA_RDOC)
    rd.options = RDOC_OPTS
  end

  spec = Gem::Specification.new do |s|
    s.name = 'cuporter'
    s.version = '0.3.14'
    s.rubyforge_project = s.name

    s.platform = Gem::Platform::RUBY
    s.has_rdoc = true
    s.extra_rdoc_files = XTRA_RDOC
    s.rdoc_options += RDOC_OPTS
    s.summary = "Scrapes Cucumber *.feature files to build reports on tag usage and test inventory"
    s.description = s.summary
    s.author = "Tim Camper"
    s.email = 'twcamper@thoughtworks.com'
    s.homepage = 'http://github.com/twcamper/cuporter'
    s.required_ruby_version = '>= 1.8.6'
    s.add_dependency('nokogiri', '>= 1.4.1')
    s.add_dependency('gherkin', '>= 1.0.0')
    s.executables = ["cuporter"]

    s.files =  %w(LICENSE README.textile Rakefile) + 
      FileList["config/**/*", "lib/**/*.{rb,xslt}", "bin/*", "public/**/*.{css,js,gif}"].to_a

    s.require_path = "lib"
  end

  Rake::GemPackageTask.new(spec) do |p|
    p.need_zip = true
    p.need_tar = true
    p.gem_spec = spec
  end
end
