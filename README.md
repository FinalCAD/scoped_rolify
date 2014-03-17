# ScopedRolify

[![Gem Version](https://badge.fury.io/rb/scoped_rolify.png)](http://badge.fury.io/rb/scoped_rolify)

[![Code Climate](https://codeclimate.com/github/joel/scoped_rolify.png)](https://codeclimate.com/github/joel/scoped_rolify)

[![Dependency Status](https://gemnasium.com/joel/scoped_rolify.png)](https://gemnasium.com/joel/scoped_rolify)

[![Build Status](https://travis-ci.org/joel/scoped_rolify.png?branch=master)](https://travis-ci.org/joel/scoped_rolify) (Travis CI)

[![Coverage Status](https://coveralls.io/repos/joel/scoped_rolify/badge.png)](https://coveralls.io/r/joel/scoped_rolify)
                                                                              https://coveralls.io/r/joel/scoped_rolify#
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

    user.add_scope_role :moderator, Forum.first
    user.add_scope_role :moderator, Forum.new

You can play also with remove_scope_role

Method with_scoped_role and method #with_any_scoped_role

Theu methods return users for asked roles

You can not call method without instance of resource

    User.with_scoped_role :admin # Thrown MissingResourceError
    User.with_scoped_role :moderator, Forum # Thrown InstanceResourceError

Only this case it's possible

    User.with_scoped_role :moderator, Forum.first #

You can't play with none persisted object


Method ```with_any_scoped_role``` return an ```ActiveRecord::Relation``` of all users with all roles asked for one resource

## Root Resource

In some case you can add right on child resource instead of parent resource, the problem is you haven't access directly to objects throught Parent resource, for exemple

You grant user on specifc Forum, user.add_role(:moderator, Forum.first) the Forum have one Category, if you want get all moderators of this Category you can't. This modification make this possible.

    moderator_john = User.new
    moderator_jane = User.new

    geek_world = Category.new

    geek_forum = Forum.new
    nerd_forum = Forum.new

    class Forum < ActiveRecord::Base
      belongs_to :category

      def root_resource
        :category
      end
    end

    class Category < ActiveRecord::Base
      has_many :forums
    end

    geek_world.forums << geek_forum
    geek_world.forums << nerd_forum

    moderator_john.add_role(:moderator, nerd_forum)
    moderator_jane.add_role(:moderator, geek_forum)

For grab all moderators of this Category

    User.with_scoped_role :moderator, geek_world, root=true

## Contributing

1. Fork it ( http://github.com/<my-github-username>/scoped_rolify/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
