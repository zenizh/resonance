$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "acts_in_relation/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "acts_in_relation"
  s.version     = ActsInRelation::VERSION
  s.authors     = ["kami"]
  s.email       = ["kami30k@gmail.com"]
  s.homepage    = "https://github.com/kami30k/acts_in_relation"
  s.summary     = "Rails plugin that adds a relational feature to Model, such as follow, block, mute, or like and so on."
  s.description = "Rails plugin that adds a relational feature to Model, such as follow, block, mute, or like and so on."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.0"
  s.add_dependency "verbs"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
end
