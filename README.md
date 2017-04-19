# ARPG::Roles

Lets you use a Postgres array column to store an ActiveRecord model's roles.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'arpg-roles'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install arpg-roles

## Usage

First, add your array column to the model you want to have the new attributes.
You can call this column whatever you like (as long as it's not a reserved
column name, like `type` or `id`). The default is `roles`.

```ruby
ActiveRecord::Base.create_table(:users) do |t|
  t.string :name
  t.string :roles, array: true, index: { using: :gin }
  t.timestamps
end
```

Now add the `roles` to your class. An example is the easiest explanation;
imagine the `users` table has a column called `roles`...

```ruby
class User
  roles :admin, :moderator, :author, on: :roles
end
```

Now you can treat `moderator?`, `author?` and `admin?` as predicates on a
User.

```ruby
User.roles #=> [:admin, :moderator, :author]

alice = User.new(name: 'Alice', roles: 'admin') # you can use strings...
bob = User.new(name: 'Bob', roles: %i[moderator author]) # ...or arrays
cecil = User.new(name: 'Cecil', author: true) # ...or booleans

alice.admin?      #=> true
alice.moderator?  #=> false
alice.author?     #=> false
bob.admin?        #=> false
bob.moderator?    #=> true
bob.author?       #=> true
cecil.admin?      #=> false
cecil.moderator?  #=> false
cecil.author?     #=> true

User.admin.pluck(:name)     #=> ["Alice"]
User.moderator.pluck(name)  #=> ["Bob"]
User.author.pluck(:name)    #=> ["Bob", "Cecil"]
```
  
The class is given a scope for each of the roles, as well as a `roles` class
method.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then,
run `rake test` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/bjjb/arpg-roles. This project is intended to be a
safe, welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](http://contributor-covenant.org) code of
conduct.

## License

The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).
