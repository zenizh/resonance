require 'acts_as_relationship/version'

module ActsAsRelationship
  autoload :Source, 'acts_as_relationship/source'
  autoload :Target, 'acts_as_relationship/target'

  require 'acts_as_relationship/railtie' if defined?(Rails)
end
