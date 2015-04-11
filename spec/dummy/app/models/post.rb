class Post < ActiveRecord::Base
  acts_in_relation role: :target, source: :user, action: :like
end
