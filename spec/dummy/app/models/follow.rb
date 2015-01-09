class Follow < ActiveRecord::Base
  acts_as_relation_target source: :user
end
