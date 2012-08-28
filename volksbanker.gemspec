# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "volksbanker/version"

Gem::Specification.new do |s|
  s.name        = "volksbanker"
  s.version     = Volksbanker::VERSION
  s.authors     = ["Andy Stewart"]
  s.email       = ["boss@airbladesoftware.com"]
  s.homepage    = ""
  s.summary     = "Prepares Volksbank's electronic statements for upload to Freeagent."
  s.description = s.summary

  s.rubyforge_project = "volksbanker"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rake', '~> 0.9.2'
end
