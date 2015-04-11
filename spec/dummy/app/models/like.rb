class Like < ActiveRecord::Base
  acts_in_relation role: :action, source: :user, target: :post
end
