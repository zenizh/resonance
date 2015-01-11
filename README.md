# acts_in_relation

acts_in_relation is a Rails plugin that adds a relational feature to Model, such as `follow`, `block`, `mute`, or `like` and so on.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'acts_in_relation'
```

And then execute:

```
$ bundle
```

## Usage

acts_in_relation supports two way to add the feature.

First, for example, it implements `follow` function between users (User model).
The second, it implements `like` function to user's post (User and Post model).

This is an example of User model, but you can be applied to any model.

### 1. User model

In this case, add `follow` feature to User model.

At first, generate User and Follow model.

```
$ rails g model User name:string
$ rails g model Follow user_id:integer target_user_id:integer
```

Add unique index to Follow table.

```ruby
class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|
      t.integer :user_id
      t.integer :target_user_id
      t.timestamps
    end

    add_index :follows, [:user_id, :target_user_id], unique: true
  end
end
```

The last, add `acts_in_relation` method to User and Follow model.

```ruby
class User < ActiveRecord::Base
  acts_in_relation with: :follow
end

class Follow < ActiveRecord::Base
  acts_in_relation :action, source: :user, target: :user
end
```

That's it.
User instance has been added following methods:

- `user.follow(other_user)`
- `user.unfollow(other_user)`
- `user.following?(other_user)`
- `user.following`
- `other_user.followed_by?(user)`
- `other_user.followers`

Examples:

```ruby
user       = User.create(name: 'foo')
other_user = User.create(name: 'bar')

# Follow
user.follow other_user
user.following?(other_user)   #=> true
user.following                #=> <ActiveRecord::Associations::CollectionProxy [#<User id: 2, name: "bar", created_at: "2015-01-10 01:57:52", updated_at: "2015-01-10 01:57:52">]>
other_user.followed_by?(user) #=> true
other_user.followers          #=> <ActiveRecord::Associations::CollectionProxy [#<User id: 1, name: "foo", created_at: "2015-01-10 01:57:42", updated_at: "2015-01-10 01:57:42">]>

# Unfollow
user.unfollow other_user
user.following?(other_user)   #=> false
user.following                #=> <ActiveRecord::Associations::CollectionProxy []>
other_user.followed_by?(user) #=> false
other_user.followers          #=> <ActiveRecord::Associations::CollectionProxy []>
```

In the same way, it can also implement `block` or `mute` function.

```ruby
class User < ActiveRecord::Base
  acts_in_relation target: :user, with: [:follow, :block, :mute]
end
```

### 2. User and Post model

acts_in_relation is possible even between different models, such as User and Post model.
(This implementation can implement at the same time as User's `follow` function)

```ruby
class User < ActiveRecord::Base
  acts_in_relation with: :follow

  acts_in_relation :source, target: :post, with: :like
end

class Post < ActiveRecord::Base
  acts_in_relation :target, source: :user, with: :like
end

class Like < ActiveRecord::Base
  acts_in_relation :action, source: :user, target: :post
end
```

User and Post instance has been added following methods:

- `user.like(post)`
- `user.unlike(post)`
- `user.liking?(post)`
- `user.liking`
- `post.liked_by?(user)`
- `post.likers`

## Three roles

acts_in_relation has three roles, Source, Target and Action.

Following table is these role's outline.

| Role | Outline | (1) | (2) |
| --- | --- | --- | --- |
| Source | The model that performs the action. | User | User |
| Target | The model that receives the action. | User | Post |
| Action | The action takes place between two models. | Follow | Like |

## Contributing

1. Fork it ( https://github.com/kami30k/acts_in_relation/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request
