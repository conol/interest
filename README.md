# Interest

a gem to follow, follow request and block between any ActiveRecord models.

## Installation

Add this line to your application's Gemfile:

    gem 'interest'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install interest

### Post installation

#### Install migrations and models

```
bin/rails generate interest
```

#### Migrate

```
bin/rake db:migrate
```

## Usage

### Setup

Create User and Blog model as one example.

```ruby
class User < ActiveRecord::Base
  interest
end

class Blog < ActiveRecord::Base
  interest
end

user = User.create!
blog = Blog.create!
```

### Follow

To follow,

```ruby
following = user.follow!(blog)
```

returns `Following` or raises `Interest::Followable::Rejected`.

Otherwise,

```ruby
following = user.follow(blog)
```

returns `Following` or `nil`.

Returned `Following` is the following.

```ruby
following.follower == user # => true
following.followee == blog # => true
following.status # => "accepted"
```

To unfollow,

```ruby
user.unfollow(blog)
```

To check whether the user is following the blog or not,

```ruby
user.following?(blog)
```

or

```ruby
blog.followed_by?(user)
```

#### Associations

```ruby
user.following_relationships.of(Blog)
```

and

```ruby
blog.follower_relationships.of(User)
```

returns `ActiveRecord::Associations::CollectionProxy` for `Following` belongs to `User` and `Blog`.

```ruby
user.following_blogs
```

returns `ActiveRecord::Associations::CollectionProxy` for `Blog`.

```ruby
blog.follower_users
```

returns `ActiveRecord::Associations::CollectionProxy` for `User`.

"blogs" and "users" part of the above are conditional on a class.

e.g.

```ruby
other_user = OtherUser.create!
user.follow(other_user) # follows OtherUser
```

then

```ruby
user.following_other_users
```

(It's just like `"ClassName".underscore.pluralize`)

### Follow request

To request to follow,

```ruby
following = user.request_to_follow!(blog)
```

returns `Following` or raises `Interest::FollowRequestable::Rejected`.

Otherwise,

```ruby
following = user.request_to_follow!(blog)
```

returns `Following` or `nil`.

Returned `Following` is the following.

```ruby
following.status # => "pending"
```

To cancel request to follow,

```ruby
user.cancel_request_to_follow(blog)
```

To check whether the user has requested to follow the blog or not,

```ruby
user.has_requested_to_follow?(blog)
```

or

```ruby
blog.has_been_requested_to_follow?(user)
```

To accept request to follow, call `accept!` of `Following`

```ruby
following = blog.incoming_follow_requests.of(User).find(id) # `Following.find(id)' is more simply.
following.accept!
```

#### Associations

```ruby
user.outgoing_follow_requests.of(Blog)
```

and

```ruby
blog.incoming_follow_requests.of(User)
```

returns `ActiveRecord::Associations::CollectionProxy` for `Following` belongs to `User` and `Blog`

```ruby
user.follow_requestee_blogs
```

returns `ActiveRecord::Associations::CollectionProxy` for `Blog`

```ruby
blog.follow_requester_users
```

returns `ActiveRecord::Associations::CollectionProxy` for `User`

#### Note

`follow!` and `follow` methods don't check whether the user is required to request to follow the blog, so you should check it yourself.

In this case, you need to define (override) `requires_request_to_follow?` on `Blog` first.

```ruby
class Blog < ActiveRecord::Base
  # ...

  def requires_request_to_follow?(follower)
    true # or something
  end
end
```

Then, like the following

```ruby
if user.required_request_to_follow?(blog)
  user.request_to_follow(blog)
else
  user.follow(blog)
end
```

or

```ruby
result = user.follow_or_request_to_follow!(blog)

if result.followed?
  # when the user followed the blog
elsif result.requested_to_follow?
  # when the user requested to follow the blog
end
```

### Block

To block,

```ruby
blocking = blog.block!(user)
```

returns `Blocking` or raises `Interest::Blockable::Rejected`.

Otherwise,

```ruby
blocking = blog.block!(user)
```

returns `Blocking` or `nil`

Returned `Blocking` is the following

```ruby
blocking.blocker == blog # => true
blocking.blockee == user # => true
```

Blocking destroys their folow and follow request relationships if they have.

To unblock,

```ruby
blog.unblock(user)
```

To check whether the blog is blocking the user or not,

```ruby
blog.blocking?(user)
```

or

```ruby
user.blocked_by?(blog)
```

#### Associations

```ruby
blog.blocking_relationships.of(User)
```

and

```ruby
user.blocker_relationships.of(Blog)
```

returns `ActiveRecord::Associations::CollectionProxy` for `Blocking` belongs to `Blog` and `User`

```ruby
blog.blocking_users
```

returns `ActiveRecord::Associations::CollectionProxy` for `User`

```ruby
user.blocker_blogs
```

returns `ActiveRecord::Associations::CollectionProxy` for `Blog`

## Contributing

1. Fork it ( https://github.com/conol/interest/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
