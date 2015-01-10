class Follow < ActiveRecord::Base
  acts_in_relation :action, source: :user, target: :user
end
