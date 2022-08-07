lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "act_with_bag/version"

Gem::Specification.new do |s|
  s.name = "act_with_bag"
  s.version = ActWithBag::VERSION
  s.summary = "act_with_bag (baggies) gem"
  s.description = "Add a bag to a Rails model"
  s.authors = ["Dittmar Krall"]
  s.email = ["dittmar.krall@matiq.com"]
  s.homepage = "http://matiq.com"
  s.license = "MIT"
  s.platform = Gem::Platform::RUBY

  s.metadata["source_code_uri"] = "https://github.com/matique/act_with_bag"

  s.files = `git ls-files -z`.split("\x0")
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"
  s.add_development_dependency "appraisal"
  s.add_development_dependency "combustion"

  s.add_development_dependency "minitest"
  s.add_development_dependency "sqlite3"
end
