lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'bundler'

Gem::Specification.new do |s|
  s.name        = "database_exporter"
  s.version     = '0.0.3'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mike Pack"]
  s.email       = ["mikepackdev@gmail.com"]
  s.homepage    = "http://www.mikepackdev.com"
  s.summary     = %q{Access to system-level database import, export and copy capabilities.}
  s.description = %q{Experimental project to gain access to system-level database import, export and copy capabilities. It's build to handle Rail's database configuration conventions.}

  s.required_rubygems_version = ">= 1.3.6"

  s.files = %w( README.md database_exporter.gemspec ) + Dir["lib/**/*.rb"]
  s.test_files = Dir["spec/**/*.rb"]
  s.require_paths = ["lib"]
end