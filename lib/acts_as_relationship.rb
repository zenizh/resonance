require 'acts_as_relationship/version'

module ActsAsRelationship
  autoload :Source, 'acts_as_relationship/source'
  autoload :Target, 'acts_as_relationship/target'
  autoload :Verb,   'acts_as_relationship/verb'

  require 'acts_as_relationship/railtie' if defined?(Rails)
end
