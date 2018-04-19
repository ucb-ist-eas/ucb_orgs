
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ucb_orgs/version"

Gem::Specification.new do |spec|
  spec.name          = "ucb_orgs"
  spec.version       = UcbOrgs::VERSION
  spec.authors       = ["Darin Wilson"]
  spec.email         = ["darinwilson@gmail.com"]

  spec.summary       = %q{Rails extension that manages UCB org unit data}
  spec.homepage      = "https://github.com/ucb-ist-eas/ucb_orgs"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "ucb_ldap"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
