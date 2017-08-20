lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'act_with_bag/version'

Gem::Specification.new do |s|
  s.name        = 'act_with_bag'
  s.version     = ActWithBag::VERSION
  s.summary     = %q{act_with_bag (baggies) gem}
  s.description = %q{Add a bag to a Rails model}
  s.authors     = ['Dittmar Krall']
  s.email       = ['dittmar.krall@matique.de']
  s.homepage    = 'http://matique.de'

  s.license     = 'MIT'
  s.platform    = Gem::Platform::RUBY

  s.files         = `git ls-files -z`.split("\x0")
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_development_dependency 'bundler', '~> 1'
  s.add_development_dependency 'rake', '~> 12'
  s.add_development_dependency 'appraisal', '~> 2'
#  s.add_development_dependency 'combustion', '~> 0'
end
