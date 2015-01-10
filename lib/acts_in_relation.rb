require 'acts_in_relation/version'

module ActsInRelation
  autoload :Core,   'acts_in_relation/core'
  autoload :Source, 'acts_in_relation/source'
  autoload :Target, 'acts_in_relation/target'
  autoload :Action, 'acts_in_relation/action'

  module Supports
    autoload :Verb, 'acts_in_relation/supports/verb'
  end

  require 'acts_in_relation/railtie' if defined?(Rails)
end
