# Maintain your gem's version:
require_relative "lib/eots/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "eots"
  s.version     = EOTS::VERSION
  s.authors     = ["Dave Aronson"]
  s.email       = ["github.2.trex@codosaur.us"]
  s.homepage    = "https://github.com/davearonson/eots"
  s.summary     = "Gem to declare multiples kinds of email -- Email of the Species"
  s.description = "Gem to programmatically declare multiples kinds of email and automagically construct forms, including view, routes, controller, etc."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails"  # any version will do
  s.add_development_dependency "rspec-rails"

  s.test_files = Dir["spec/**/*"]
end
