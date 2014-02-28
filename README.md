# ScopedRolify

[![Gem Version](https://badge.fury.io/rb/scoped_rolify.png)](http://badge.fury.io/rb/scoped_rolify)

[![Code Climate](https://codeclimate.com/github/joel/scoped_rolify.png)](https://codeclimate.com/github/joel/scoped_rolify)

[![Dependency Status](https://gemnasium.com/joel/scoped_rolify.png)](https://gemnasium.com/joel/scoped_rolify)

[![Build Status](https://travis-ci.org/joel/scoped_rolify.png?branch=master)](https://travis-ci.org/joel/scoped_rolify) (Travis CI)

[![Coverage Status](https://coveralls.io/repos/joel/scoped_rolify/badge.png)](https://coveralls.io/r/joel/scoped_rolify)

This is a monkey patch of rolify for specifics purposes. We want only have users scoped on specific instance of resource. We are no really interesting by hierarchy.

## Installation

Add this line to your application's Gemfile:

    gem 'scoped_rolify'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scoped_rolify

## Usage

Method #add_scope_role map #add_role

You can not add right without instance of resource

    user = User.find(1)
    user.add_scope_role :admin # Thrown MissingResourceError
    user.add_scope_role :moderator, Forum # Thrown InstanceResourceError

Only this case it's possible

    user.add_scope_role :moderator, Forum.first #

Method with_scoped_role map #with_role

You can not call method without instance of resource

    User.with_scoped_role :admin # Thrown MissingResourceError
    User.with_scoped_role :moderator, Forum # Thrown InstanceResourceError

Only this case it's possible

    User.with_scoped_role :moderator, Forum.first #

## Contributing

1. Fork it ( http://github.com/<my-github-username>/scoped_rolify/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
