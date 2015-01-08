class User < ActiveRecord::Base
  include ActsAsRelationship

  acts_as_relation_source :user, with: [:follow]
end
