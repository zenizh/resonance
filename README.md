# Resonance

[![Build Status](https://travis-ci.org/kami-zh/resonance.svg)](https://travis-ci.org/kami-zh/resonance)
[![Gem Version](https://badge.fury.io/rb/resonance.svg)](http://badge.fury.io/rb/resonance)

Resonance provides a relational feature to your Rails application, such as follow, like, and so on.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'resonance'
```

And then execute:

```
$ bundle
```

## Usage

Resonance supports two way to add relational feature.

1. Add a feature to itself
2. Add features to two models

Following example shows about User model, however, you can apply to any models.

### 1. Add follow feature to User

This case adds follow feature to User model.

At first, generate User and Follow model:

```
$ bin/rails g model User
$ bin/rails g model Follow user_id:integer target_user_id:integer
```

And migrate:

```
$ bin/rake db:migrate
```

Then, define `Resonatable` module to `app/models/concerns/resonatable.rb`:

```ruby
module Resonatable
  include Resonance

  resonate :user, with: :user, by: :follow
end
```

At last, include this module from each models:

```ruby
class User < ActiveRecord::Base
  include Resonatable
end

class Follow < ActiveRecord::Base
  include Resonatable
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

### 2. Add like feature to User and Post

This case adds like feature to User and Post model.

```ruby
module Resonatable
  include Resonance

  resonate :user, with: :post, by: :like
end

class User < ActiveRecord::Base
  include Resonatable
end

class Post < ActiveRecord::Base
  include Resonatable
end

class Like < ActiveRecord::Base
  include Resonatable
end
```

User and Post instance has been added following methods:

- user.like(post)
- user.unlike(post)
- user.liking?(post)
- user.liking
- post.liked_by?(user)
- post.likers

At the same time, some `resonate` methods are able to be defined:

```ruby
module Resonatable
  include Resonance

  resonate :user, with: :user, by: :follow
  resonate :user, with: :post, by: :like
end
```

## Customization

If you want to use other foreign key name, you can define it by `:foreign_key` option.

```ruby
resonate :user, with: :post, by: :like, foreign_key: :post_id # Default is `:target_post_id`
```

## Contributing

1. Fork it ( https://github.com/kami-zh/resonance/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request
