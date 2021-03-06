$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dtu_blacklight_common/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "dtu_blacklight_common"
  spec.version     = DtuBlacklightCommon::VERSION
  spec.authors     = ["Ronan McHugh", "Matt Zumwalt"]
  spec.email       = ["romc@dtu.dk"]
  spec.homepage    = "https://github.com/dtulibrary/dtu_blacklight_common"
  spec.summary     = "Shared Blacklight functionality for Toshokan and DDF."
  spec.description = "A Rails engine that provides shared Blacklight functionality for Toshokan and DDF"
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  spec.test_files = Dir["spec/**/*"]

  spec.add_dependency "rails", "~> 4.1"
  spec.add_dependency "solr_wrapper"
  spec.add_dependency "blacklight", '~> 5.7.0'
  spec.add_dependency "twitter-typeahead-rails", '~> 0.11'
  spec.add_dependency "font-awesome-rails"

  spec.add_development_dependency 'execjs'
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "capybara"
  spec.add_development_dependency "engine_cart"
  spec.add_development_dependency "xray-rails"
end
