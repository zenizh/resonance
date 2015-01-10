class Like < ActiveRecord::Base
  acts_in_relation :action, source: :user, target: :post
end
