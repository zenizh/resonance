class User < ActiveRecord::Base
  acts_in_relation role: :self, action: [:follow, :block, :mute]

  acts_in_relation role: :source, target: :post, action: :like
end
