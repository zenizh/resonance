$:.unshift File.expand_path('../lib', __FILE__)

require 'resonance/version'

Gem::Specification.new do |s|
  s.name        = 'resonance'
  s.version     = Resonance::VERSION
  s.authors     = 'kami'
  s.email       = 'hiroki.zenigami@gmail.com'

  s.summary     = 'Provides a relational feature to your Rails application.'
  s.description = 'Provides a relational feature to your Rails application.'
  s.homepage    = 'https://github.com/kami-zh/resonance'
  s.license     = 'MIT'

  s.files = `git ls-files -z`.split("\x0")

  s.add_dependency 'inflexion'

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'actionpack'
  s.add_development_dependency 'activerecord'
  s.add_development_dependency 'sqlite3'
end
