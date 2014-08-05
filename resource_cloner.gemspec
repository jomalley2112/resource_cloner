$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "resource_cloner/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "resource_cloner"
  s.version     = ResourceCloner::VERSION
  s.authors     = ["John O'Malley"]
  s.email       = ["jom@nycap.rr.com"]
  s.homepage    = ""
  s.summary     = "Clones a resources model, controller, views,..."
  s.description = ""
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.4"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pry-rails"
end
