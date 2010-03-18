# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ftp_service}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Justin Blake"]
  s.date = %q{2010-03-18}
  s.description = %q{An FTP Service is like a web service except stupid. You send your request by uploading an xml file and get your response by downloading another xml file.}
  s.email = %q{justin@megablaix.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.markdown"
  ]
  s.files = [
    ".gitignore",
     "CHANGELOG.markdown",
     "LICENSE",
     "README.markdown",
     "Rakefile",
     "TODO.markdown",
     "VERSION",
     "cucumber.yml",
     "features/basic_request.feature",
     "features/encrypted_request.feature",
     "features/step_definitions/ftp_request_steps.rb",
     "features/support/env.rb",
     "features/support/ftp_helper.rb",
     "ftp_service.gemspec",
     "lib/ftp_service.rb",
     "lib/ftp_service/encryption.rb",
     "lib/tempfile_helper.rb",
     "spec/ftp_service_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "spec/tempfile_helper_spec.rb",
     "test_keys/pubring.gpg",
     "test_keys/secring.gpg",
     "test_keys/trustdb.gpg"
  ]
  s.homepage = %q{http://github.com/blaix/ftp_service}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{A class for dealing with the worst possible type of "web" service.}
  s.test_files = [
    "spec/ftp_service_spec.rb",
     "spec/spec_helper.rb",
     "spec/tempfile_helper_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ruby_gpg>, [">= 0.2.0"])
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_development_dependency(%q<mocha>, [">= 0.9.8"])
      s.add_development_dependency(%q<yard>, [">= 0.5.3"])
      s.add_development_dependency(%q<cucumber>, [">= 0.6.3"])
    else
      s.add_dependency(%q<ruby_gpg>, [">= 0.2.0"])
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_dependency(%q<mocha>, [">= 0.9.8"])
      s.add_dependency(%q<yard>, [">= 0.5.3"])
      s.add_dependency(%q<cucumber>, [">= 0.6.3"])
    end
  else
    s.add_dependency(%q<ruby_gpg>, [">= 0.2.0"])
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
    s.add_dependency(%q<mocha>, [">= 0.9.8"])
    s.add_dependency(%q<yard>, [">= 0.5.3"])
    s.add_dependency(%q<cucumber>, [">= 0.6.3"])
  end
end

