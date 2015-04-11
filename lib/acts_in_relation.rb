require 'acts_in_relation/version'
require 'acts_in_relation/railtie' if defined?(Rails)

module ActsInRelation
  class MissingRoleError < StandardError; end

  class UnknownRoleError < StandardError
    def initialize(role)
      @role = role
    end

    def to_s
      ":role should be one of :source, :target, :action or :self (#{@role} is passed)"
    end
  end

  autoload :Core, 'acts_in_relation/core'

  module Roles
    autoload :Base,   'acts_in_relation/roles/base'
    autoload :Source, 'acts_in_relation/roles/source'
    autoload :Target, 'acts_in_relation/roles/target'
    autoload :Action, 'acts_in_relation/roles/action'
  end

  module Supports
    autoload :Verb, 'acts_in_relation/supports/verb'
  end
end
