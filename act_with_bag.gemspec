$:.push File.expand_path('../lib', __FILE__)

require 'act_with_bag/version'

Gem::Specification.new do |s|
  s.name        = 'act_with_bag'
  s.version     = ActWithBag::VERSION
  s.licenses    = ['MIT']
  s.platform    = Gem::Platform::RUBY
  s.summary     = %q{act_with_bag (baggies) gem}
  s.description = %q{Add a bag to a Rails model}
  s.authors     = ['Dittmar Krall']
  s.email       = ['dittmar.krall@matique.de']
  s.homepage    = 'http://matique.de'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency 'sqlite3', '~> 0'  # for testing
end
