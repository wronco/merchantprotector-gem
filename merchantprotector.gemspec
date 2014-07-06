# -*- encoding: utf-8 -*-
require File.expand_path('../lib/merchantprotector/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Will Ronco"]
  gem.email         = ["will@merchantprotector.net"]
  gem.description   = %q{Rails plugin to send ecommerce order details to Merchant Protector}
  gem.summary       = %q{Adds customer information to Stripe orders in Merchant Protector fraud screening}
  gem.homepage      = "https://github.com/wronco/merchantprotector-gem"
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.name          = "merchantprotector"
  gem.require_paths = ["lib"]
  gem.version       = Merchantprotector::VERSION

  gem.add_runtime_dependency 'multi_json', '~> 1.10'

  gem.add_development_dependency 'rails', '~> 3.2'
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rspec-nc"
  gem.add_development_dependency "guard"
  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "pry-remote"
  gem.add_development_dependency "pry-nav"
  gem.add_development_dependency "webmock"
end