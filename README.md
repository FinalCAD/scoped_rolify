# Scopable

[![Code Climate](https://codeclimate.com/github/joel/scopable.png)](https://codeclimate.com/github/joel/scopable)

[![Dependency Status](https://gemnasium.com/joel/scopable.png)](https://gemnasium.com/joel/scopable)

[![Build Status](https://travis-ci.org/joel/scopable.png?branch=master)](https://travis-ci.org/joel/scopable) (Travis CI)

[![Coverage Status](https://coveralls.io/repos/joel/scopable/badge.png)](https://coveralls.io/r/joel/scopable)

This is a monkey patch of rolify for specifics purposes. We want only have users scoped on specific instance of resource. We are no really interesting by hierarchy.

## Installation

Add this line to your application's Gemfile:

    gem 'scopable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scopable

## Usage

You can not add right without instance of resource

  user = User.find(1)
  user.add_role :admin # Thrown MissingResourceError
  user.add_role :moderator, Forum # Thrown InstanceResourceError

Only this case it's possible

  user.add_role :moderator, Forum.first #

## Contributing

1. Fork it ( http://github.com/<my-github-username>/scopable/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
