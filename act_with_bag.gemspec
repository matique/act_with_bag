# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "act_with_bag/version"

Gem::Specification.new do |s|
  s.name        = "act_with_bag"
  s.version     = ActWithBag::VERSION
  s.authors     = ["matique"]
  s.email       = ["dittmar.krall@matique.de"]
  s.homepage    = ""
  s.summary     = %q{act_with_bag (baggies) gem}
  s.description = %q{Add a bag to a Rails model}

  s.rubyforge_project = "act_with_bag"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"

  s.add_development_dependency "sqlite3"
end
