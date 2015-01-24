# Fortress

[![Build Status](https://travis-ci.org/YourCursus/fortress.svg?branch=master)](https://travis-ci.org/YourCursus/fortress) [![Code Climate](https://codeclimate.com/github/YourCursus/fortress/badges/gpa.svg)](https://codeclimate.com/github/YourCursus/fortress) [![Gem Version](https://badge.fury.io/rb/fortress.svg)](http://badge.fury.io/rb/fortress)

Implement the simple but powerful protection: close everything and open the
access explecitely.

As of today, and as far as I know, all protection libraries are bases on the
principle that all is open and you close when need which can leads to security
holes in the case you've forgotten to close a route.

It's probabely better to refuse the access to a page where a user should be
allowed to access it than allowing access to a page where a user should not be
allowed to access and let him sees things he shouldn't.

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
closed. At this moment your application is absoluetly un-usable so it's in the
maximum secure mode ; )

### Configuration

#### externals

When using a gem adding controllers to your application, like Devise, Fortress
needs to be aware of them otherwise it will prevent access to them.

You can do this by using the `externals` option within an initializer:

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

Given the root controller of your application is the `WelcomeController` then
you can allow to access it with the following:

```ruby
class WelcomeController < ApplicationController
  fortress_allow :all

  def index
    # ...
  end
end
```

`fortress_allow` is the only method you need to know. Giving the `:all`
argument as parameter revert the behavior to the default one: All is open for
this controller.
It's simple and easy to use in public controllers (no data with limited access)
but I highly recommend you to use it as less as possible.

### Allow a specific action

Now you want to allow access to an action of another controller.

In the case you don't have specific need you can write the following:

```ruby
class PostsController < ApplicationController
  fortress_allow :index

  def index
    # ...
  end
end
```


### Allow all actions except one

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

Note: This reduce a little bit the security as if you add a new action to the
controller and you haven't updated Fortress, the action will be allowed.

### Allowing on condition

Finally you can use the `:if` key in order to allow only when the condition is
true.

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

You will see which controller is called and then blocked by the prevent_access!
method from Fortress.

## Contributing

1. Fork it ( https://github.com/YourCursus/fortress/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
