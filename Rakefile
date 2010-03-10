require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "ftp_service"
    gem.summary = %Q{A class for dealing with the worst possible type of "web" service.}
    gem.description = %Q{An FTP Service is like a web service except stupid. You send your request by uploading an xml file and get your response by downloading another xml file.}
    gem.email = "justin@megablaix.com"
    gem.homepage = "http://github.com/blaix/ftp_service"
    gem.authors = ["Justin Blake"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_development_dependency "mocha", ">= 0.9.8"
    gem.add_development_dependency "yard", ">= 0.5.3"
    gem.add_development_dependency "cucumber", ">= 0.6.3"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features)

namespace :spec do
  Spec::Rake::SpecTask.new(:doc) do |spec|
    spec.libs << 'lib' << 'spec'
    spec.spec_files = FileList['spec/**/*_spec.rb']
    spec.spec_opts << '--format specdoc'
  end
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new do |y|
    y.files << '-' << 'CHANGELOG.*'
  end
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end
