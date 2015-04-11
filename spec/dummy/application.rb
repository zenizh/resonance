require 'action_controller/railtie'
require 'active_record'

require 'acts_in_relation'

module Dummy
  class Application < Rails::Application
    config.secret_token = 'abcdefghijklmnopqrstuvwxyz0123456789'
    config.session_store :cookie_store, key: '_dummy_session'
    config.eager_load = false
    config.active_support.deprecation = :log
  end
end

Dummy::Application.initialize!

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

#
# Models
#

class User < ActiveRecord::Base
  acts_in_relation role: :self, action: [:follow, :block, :mute]

  acts_in_relation role: :source, target: :post, action: :like
end

class Post < ActiveRecord::Base
  acts_in_relation role: :target, source: :user, action: :like
end

class Follow < ActiveRecord::Base
  acts_in_relation role: :action, self: :user
end

class Like < ActiveRecord::Base
  acts_in_relation role: :action, source: :user, target: :post
end

#
# Migrates
#

class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.timestamps null: false
    end
  end
end

class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.timestamps null: false
    end
  end
end

class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|
      t.integer :user_id
      t.integer :target_user_id

      t.timestamps null: false
    end
  end
end

class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.integer :target_post_id

      t.timestamps null: false
    end
  end
end

CreateUsers.new.change
CreatePosts.new.change
CreateFollows.new.change
CreateLikes.new.change
