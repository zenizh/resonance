class Follow < ActiveRecord::Base
  include ActsAsRelationship

  acts_as_relation_target :user
end
