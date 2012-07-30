# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rlagoon/version"

Gem::Specification.new do |s|
  s.name        = "rlagoon"
  s.version     = Rlagoon::VERSION
  s.authors     = ["balmeida"]
  s.email       = ["balmeida@ipn.pt"]
  s.homepage    = ""
  s.summary     = %q{This gem helps integrate your application with Lagoon API}
  s.description = %q{This gem helps integrate your application with Lagoon API v0.0.1}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_runtime_dependency "httparty", '=0.7.8'
  
  s.add_development_dependency 'httparty', '=0.7.8'
  s.add_development_dependency 'rspec', '~> 2.6.0'
  s.add_development_dependency 'rails', '~> 3.0.9'
  s.required_rubygems_version = ">= 1.3.4"
end
