require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  warn e.message
  warn 'Run `bundle install` to install missing gems'
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = 'bio-liftover'
  gem.homepage = 'http://github.com/andreirozanski/bioruby-liftover'
  gem.license = 'MIT'
  gem.summary = %{Ruby solution for UCSC LiftOver tool- (UCSC http://genome.ucsc.edu/cgi-bin/hgLiftOver)}
  gem.description = %(Simple, under development Ruby solution for UCSC LiftOver tool)
  gem.email = 'andrei@ruivo.org'
  gem.authors = ['Andrei Rozanski']
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task default: :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ''

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "bio-liftover #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
