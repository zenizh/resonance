class User < ActiveRecord::Base
  acts_as_relation_source target: :user, with: [:follow]
end
