$:.unshift File.expand_path('../../../lib', __FILE__)

require 'action_controller/railtie'
require 'active_record'
require 'resonance'

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

class User   < ActiveRecord::Base; end
class Post   < ActiveRecord::Base; end
class Follow < ActiveRecord::Base; end
class Like   < ActiveRecord::Base; end

module Resonatable
  include Resonance

  resonate :user, target: :user, action: :follow
  resonate :user, target: :post, action: :like, foreign_key: { target: :post_id }
end

class User
  include Resonatable
end

class Post
  include Resonatable
end

class Follow
  include Resonatable
end

class Like
  include Resonatable
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
      t.integer :post_id

      t.timestamps null: false
    end
  end
end

CreateUsers.new.change
CreatePosts.new.change
CreateFollows.new.change
CreateLikes.new.change
