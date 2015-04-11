# acts_in_relation

[![Build Status](https://travis-ci.org/kami30k/acts_in_relation.svg)](https://travis-ci.org/kami30k/acts_in_relation)
[![Gem Version](https://badge.fury.io/rb/acts_in_relation.svg)](http://badge.fury.io/rb/acts_in_relation)

acts_in_relation adds relational feature to Rails application, such as follow, block, like and so on.

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

acts_in_relation supports two way to add relational feature.

1. Add feature to oneself
2. Add feature to between two models

Following example shows about User model, however, you can apply to any models.

### 1. Add follow feature to User

This case adds follow feature to User model.

At first, generate User and Follow model:

```
$ bin/rails g model User
$ bin/rails g model Follow user_id:integer target_user_id:integer
```

Then migrate:

```
$ bin/rake db:migrate
```

At last, add `acts_in_relation` method to each models:

```ruby
class User < ActiveRecord::Base
  acts_in_relation role: :self, action: :follow
end

class Follow < ActiveRecord::Base
  acts_in_relation role: :action, self: :user
end
```

That's it.
User instance has been added following methods:

- user.follow(other_user)
- user.unfollow(other_user)
- user.following?(other_user)
- user.following
- other_user.followed_by?(user)
- other_user.followers

Example:

```ruby
user       = User.create
other_user = User.create

# Follow
user.follow other_user
user.following?(other_user)   #=> true
user.following                #=> <ActiveRecord::Associations::CollectionProxy [#<User id: 2, created_at: "2015-01-10 01:57:52", updated_at: "2015-01-10 01:57:52">]>
other_user.followed_by?(user) #=> true
other_user.followers          #=> <ActiveRecord::Associations::CollectionProxy [#<User id: 1, created_at: "2015-01-10 01:57:42", updated_at: "2015-01-10 01:57:42">]>

# Unfollow
user.unfollow other_user
user.following?(other_user)   #=> false
user.following                #=> <ActiveRecord::Associations::CollectionProxy []>
other_user.followed_by?(user) #=> false
other_user.followers          #=> <ActiveRecord::Associations::CollectionProxy []>
```

At the same time, `:action` is able to be passed some actions:

```ruby
class User < ActiveRecord::Base
  acts_in_relation role: :self, action: [:follow, :block, :mute]
end
```

### 2. Add like feature to User and Post

This case adds like feature to User and Post model.

```ruby
class User < ActiveRecord::Base
  acts_in_relation role: :source, target: :post, action: :like
end

class Post < ActiveRecord::Base
  acts_in_relation role: :target, source: :user, action: :like
end

class Like < ActiveRecord::Base
  acts_in_relation role: :action, source: :user, target: :post
end
```

User and Post instance has been added following methods:

- user.like(post)
- user.unlike(post)
- user.liking?(post)
- user.liking
- post.liked_by?(user)
- post.likers

At the same time, some `acts_in_relation` methods are able to be defined:

```ruby
class User < ActiveRecord::Base
  acts_in_relation role: :self, action: :follow
  acts_in_relation role: :source, target: :post, action: :like
end
```

## Roles

acts_in_relation has three roles: source, target and action.

| Role | Outline | (1) | (2) |
| --- | --- | --- | --- |
| source | The model that performs the action. | User | User |
| target | The model that receives the action. | User | Post |
| action | The action performs between two models. | Follow | Like |

## Contributing

1. Fork it ( https://github.com/kami30k/acts_in_relation/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request
