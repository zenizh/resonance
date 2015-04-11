class Follow < ActiveRecord::Base
  acts_in_relation role: :action, self: :user
end
