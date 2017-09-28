# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'certify_notifications/version'

# rubocop:disable BlockLength
Gem::Specification.new do |spec|
  spec.name          = "certify_notifications"
  spec.version       = CertifyNotifications::VERSION::STRING
  spec.authors       = ["Fearless"]
  spec.email         = [""]

  spec.summary       = "Ruby Gem to wrap the Certify Notification API"
  spec.description   = "Ruby Gem to wrap the Certify Notification API (GIT_DESCRIBE)"
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = 'http://artifactory.maint.sba-one.net:8081/artifactory/api/gems/gems-local' # "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "faker"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-rspec"
  spec.add_development_dependency "simplecov"

  spec.add_dependency "excon"
  spec.add_dependency "excon-rails"
  spec.add_dependency "json"

end
