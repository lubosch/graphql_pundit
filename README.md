[![Build Status](https://travis-ci.com/lubosch/graphql_pundit.svg?branch=master)](https://travis-ci.com/lubosch/graphql_pundit)
[![Coverage Status](https://codecov.io/gh/lubosch/graphql_pundit/branch/master/graph/badge.svg)](https://codecov.io/gh/lubosch/graphql_pundit)

# GraphQL::Pundit

Use field authorize api with pundit

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'graphql_pundit'
```

And then execute:

```bash
$ bundle
```

## Upgrading notes

# If you are coming from ontobot

Add this to your BaseField:

```
def initialize(*args, raise_unauthorized: false, authorize: nil, record: nil, policy: nil, **kwargs, &block)
  super(*args, **kwargs, &block)
  @raise_unauthorized = raise_unauthorized
  @authorize = authorize
  @record = record
  @policy = policy
  extension(GraphqlPundit::AuthorizationExtension, current_user: :current_user)
end
```

## Usage

```ruby
class Car < BaseObject
  field :trunk, CarContent, null: true,
                            authorize: true
end
```

The above example shows the most basic usage of this gem. The example would
use `CarPolicy#trunk?` for authorizing access to the field, passing in the
parent object (in this case probably a `Car` model).

##### Options

Two styles of declaring fields is supported:

1. the inline style, passing all the options as a hash to the field method
2. the block style

Both styles are presented below side by side.

###### `authorize`

To use authorization on a field, you **must** pass either the `authorize`
option. Both options will cause the field to return `nil` if the
access is unauthorized. Use `raise_unauthorized: true` to also add an error message (e.g.
for usage with mutations).

`authorize` can be passed three different things:

```ruby
class User < BaseObject
  # will use the `UserPolicy#display_name?` method
  field :display_name, ..., authorize: true

  # will use the passed lambda instead of a policy method
  field :password_hash, ..., authorize: ->(obj, args, ctx) { ... }

  # will use the `UserPolicy#personal_info?` method
  field :email, ..., authorize: :personal_info
end
```

- `true` will trigger the inference mechanism, meaning that the method that will be called on the policy class will be inferred from the (snake_case) field name.
- a lambda function that will be called with the parent object, the arguments of the field and the context object; if the lambda returns a truthy value, authorization succeeds; otherwise (including thrown exceptions), authorization fails
- a string or a symbol that corresponds to the policy method that should be called **minus the "?"**

###### `policy`

`policy` is an optional argument that can also be passed three different values:

```ruby
class User < BaseObject
  # will use the `UserPolicy#display_name?` method (default inference)
  field :display_name, ..., authorize: true, policy: nil

  # will use OtherUserPolicy#password_hash?
  field :password_hash, ...,
                        authorize: true,
                        policy: ->(obj, args, ctx) { OtherUserPolicy }

  # will use MemberPolicy#email?
  field :email, ..., authorize: true, policy: MemberPolicy
end
```

- `nil` is the default behavior and results in inferring the policy class from the record (see below)
- a lambda function that will be called with the parent object, the arguments of the field and the context object; the return value of this function will be used as the policy class
- an actual policy class

###### `record`

`record` can be used to pass a different value to the policy. Like `policy`,
this argument also can receive three different values:

```ruby
class User < BaseObject
  # will use the parent object
  field :display_name, ..., authorize: true, record: nil

  # will use the current user as the record
  field :password_hash, ...,
                        authorize: true,
                        record: ->(obj, args, ctx) { ctx[:current_user] }

  # will use AccountPolicy#email? with the first account as the record (the policy was inferred from the record class)
  field :email, ..., authorize: true, record: Account.first
end
```

- `nil` is again used for the inference; in this case, the parent object is used
- a lambda function, again called with the parent object, the field arguments and the context object; the result will be used as the record
- any other value that will be used as the record

Using `record` can be helpful for e.g. mutations, where you need a value to
initialize the policy with, but for mutations there is no parent object.

#### Current user

By default, `ctx[:current_user]` will be used as the user to authorize. To change that behavior, pass a symbol to `GraphQL::Pundit::Instrumenter`.

```ruby
GraphQL::Pundit::Instrumenter.new(:me) # will use ctx[:me]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lubosch/graphql-pundit.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

