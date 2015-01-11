class Post < ActiveRecord::Base
  acts_in_relation :target, source: :user, with: :like
end
