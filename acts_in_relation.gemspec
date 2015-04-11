$:.unshift File.expand_path('../lib', __FILE__)

require 'acts_in_relation/version'

Gem::Specification.new do |s|
  s.name        = 'acts_in_relation'
  s.version     = ActsInRelation::VERSION
  s.authors     = 'kami'
  s.email       = 'kami30k@gmail.com'

  s.summary     = 'Add relational feature to Rails (e.g. follow, block and like).'
  s.description = 'Add relational feature to Rails (e.g. follow, block and like).'
  s.homepage    = 'https://github.com/kami30k/acts_in_relation'
  s.license     = 'MIT'

  s.files = `git ls-files -z`.split("\x0")

  s.add_dependency 'rails'
  s.add_dependency 'verbs'
  s.add_dependency 'caller_class'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
end
