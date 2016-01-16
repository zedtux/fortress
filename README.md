# Fortress

[![Build Status](https://travis-ci.org/YourCursus/fortress.svg?branch=master)](https://travis-ci.org/YourCursus/fortress) [![Code Climate](https://codeclimate.com/github/YourCursus/fortress/badges/gpa.svg)](https://codeclimate.com/github/YourCursus/fortress) [![Gem Version](https://badge.fury.io/rb/fortress.svg)](http://badge.fury.io/rb/fortress) [![Test Coverage](https://codeclimate.com/github/YourCursus/fortress/badges/coverage.svg)](https://codeclimate.com/github/YourCursus/fortress)

Protect your Rails application using the simple but powerful principle **close everything, open explicitly**.

When you create a new Rails application, and you add a new route, you will use `resourses :users` for instance, which creates all the CRUD actions, open without restrictions.
You then need to either prevent the action creation using `only: :action_name` or `except: :action_name`, or in the controller add some `before_action` in order to check the user access.

This gem implements a security mechanism which will reject all calls to controller actions which have not been allowed.
(Better reject access and then allow it, than allowing the user accessing a place he shouldn't and then closing it.)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fortress'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fortress

## Usage

After having installed the gem, and started the server, all the routes are
closed.
At this moment your application is no accessible at all, so you need to start to allow accessing some controller actions.

### Configuration

#### externals

When using a gem adding controllers to your application, like Devise for example, Fortress needs to be aware of those controllers in order to allow access.

You can do this using the `externals` option within an initializer:

```ruby
Fortress.configure do |config|
  config.externals = %w(SessionsController)
end
```

### Allow access to the root controller

The first action to take is to allow the root controller as it's the place
where the user will be redirected in case he tries to access a place where he
is not allowed to.
(he is redirected to the `root_url` and a flash message `:error` is displayed.)

Given the root controller of your application is the `WelcomeController`,
you can allow accessing it with the following:

```ruby
class WelcomeController < ApplicationController
  fortress_allow :all

  def index
    # ...
  end
end
```

`fortress_allow` is the only method you need to know.

Here the `:all` argument will allow accessing all existing and future actions of the controller, which is the default Rails behavior.
It's simple and easy to use in public controllers (no data with limited access)
but I highly recommend you to use it as less as possible.

### Allow access to a specific action

In this example, we allow anyone (no checks on the user) to access the `index` action.

```ruby
class PostsController < ApplicationController
  fortress_allow :index

  def index
    # ...
  end
end
```

### Allow access to all actions excepted one

Let's say you have a controller with 4 actions and you want to allow all of
them except one.

You can specify each actions by hand:

```ruby
class PostsController < ApplicationController
  fortress_allow [:index, :show, :download]

  def index; end

  def show; end

  def destroy; end

  def download; end
end
```

Or you can combine `:all` with `:except`

```ruby
class PostsController < ApplicationController
  fortress_allow :all, except: :destroy

  def index; end

  def show; end

  def destroy; end

  def download; end
end
```

Note: This reduce a little bit the security level as in the case you add a new action to the controller but you don't update the `fortress_allow`, the action will be allowed.

### Allowing access with condition

Finally you can use the `:if` key in order to allow only when the condition is
`true`.

```ruby
class PostsController < ApplicationController
  fortress_allow :all, except: :destroy
  fortress_allow :destroy, if: :is_admin?

  def index; end

  def show; end

  def destroy; end

  def download; end

  private

  def is_admin?
    current_user.admin?
  end
end
```

## Detecting blocked controllers

It can be a little bit hard to find all the blocked controller in a big
application.

I recommend you to use the following command:

    $ tail -f log/*.log | grep prevent_access -B 5

You will see which controllers are called and then blocked by the `prevent_access!`
method from Fortress.

## Contributing

1. Fork it ( https://github.com/YourCursus/fortress/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
