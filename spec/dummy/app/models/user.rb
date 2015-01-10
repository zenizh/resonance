class User < ActiveRecord::Base
  # acts_in_relation with: [:follow, :block, :mute]

  acts_in_relation :source, target: :post, with: [:like]
end
