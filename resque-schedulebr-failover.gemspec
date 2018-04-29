
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "resque/schedulebr/failover/version"

Gem::Specification.new do |spec|
  spec.name          = "resque-schedulebr-failover"
  spec.version       = Resque::Schedulebr::Failover::VERSION
  spec.authors       = ["jiikko"]
  spec.email         = ["n905i.1214@gmail.com"]

  spec.summary       = %q{this gem is to failover for resque-scheduler.}
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/jiikko/resque-scheduler-failover'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'appraisal'

  spec.add_dependency 'resque-scheduler'
end
