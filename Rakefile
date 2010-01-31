require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rails_action_args"
    gem.summary = %Q{A port of merb-action-args to rails}
    gem.description = %Q{Big thanks to the original authors. Let me know if I missed you. Action args rocks and you deserve the credit :)}
    gem.email = "collintmiller@gmail.com"
    gem.homepage = "http://github.com/collin/rails_action_args"
    gem.authors = [
      "ezmobius",
      "mattetti",
      "maiha",
      "Yehuda Katz",
      "Andy Delcambre",
      "Janne Asmala",
      "Collin Miller"
    ]
    gem.add_dependency "actionpack",         ">=3.0.pre"
    gem.add_dependency "ParseTree",          ">=3.0.4"
    gem.add_dependency "ruby2ruby",          ">=1.2.4"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rails_action_args #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end