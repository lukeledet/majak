# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'majak/version'

Gem::Specification.new do |spec|
  spec.name          = "majak"
  spec.version       = Majak::VERSION
  spec.authors       = ["Luke Ledet"]
  spec.email         = ["luke@lootbox.org"]
  spec.summary       = %q{Boat computer}
  spec.description   = %q{Autopilot and navigation for my sailboat, oddly named Majak (pronounced like magic).}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "vincenty"
  #spec.add_dependency "wiringpi"
  spec.add_dependency "eventmachine"
  spec.add_dependency "rb-pid-controller"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"

  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-minitest"
  spec.add_development_dependency "terminal-notifier-guard"
  spec.add_development_dependency "terminal-notifier"
#  spec.add_development_dependency "tcr"
end
