# ScopedRolify

[![Gem Version](https://badge.fury.io/rb/scoped_rolify.png)](http://badge.fury.io/rb/scoped_rolify)

[![Code Climate](https://codeclimate.com/github/joel/scoped_rolify.png)](https://codeclimate.com/github/joel/scoped_rolify)

[![Dependency Status](https://gemnasium.com/joel/scoped_rolify.png)](https://gemnasium.com/joel/scoped_rolify)

[![Build Status](https://travis-ci.org/joel/scoped_rolify.png?branch=master)](https://travis-ci.org/joel/scoped_rolify) (Travis CI)

[![Coverage Status](https://coveralls.io/repos/joel/scoped_rolify/badge.png)](https://coveralls.io/r/joel/scoped_rolify)

## Introduction

This is a hack of EppO/rolify for specific purpose and for bypassing some limitations. We want only have users scoped on specific instance of resource. We are no really interesting by hierarchy. We want use Rolify for binding some resource through roles, the resources have absolutely need to be existing.

## Installation

Add this line to your application's Gemfile:

    gem 'scoped_rolify'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scoped_rolify


# Roles

## #add_role method

We have added ```add_scope_role(role_name, resource)``` method for mapped original ```add_role``` method.

This method force argument resource to be existing, and add extra feature for ```root resource``` discussed below.

usage:

You can't add right without instance of resource

    user = User.find(1)
    user.add_scope_role :admin # Thrown MissingResourceError
    user.add_scope_role :moderator, Forum # Thrown InstanceResourceError

Only the following ways are possible

    user.add_scope_role :moderator, Forum.first
    user.add_scope_role :moderator, Forum.new

## #remove_role method

This method is mapped by #remove_scope_role

# Finders

## #with_role and #with_any_role methods

Those methods are mapped by ```#with_scoped_role``` and method ```#with_any_scoped_role```

An important enhancement here, the new methods return an ```ActiveRecord::Relation``` instead array of result! Is a big feature for us.

usage:

The methods return users for asked roles

You can't call method without instance of resource

    User.with_scoped_role :admin # Thrown MissingResourceError
    User.with_scoped_role :moderator, Forum # Thrown InstanceResourceError

Only the following ways are possible

    User.with_scoped_role :moderator, Forum.first

### Important limitation of finders

You can't play with none persisted object

## Root Resource

In some case you can add right on child resource instead of parent resource, the problem is you haven't access directly to objects through Parent resource, for exemple

You grant user on specific ```Forum```, ```user.add_scope_role(:moderator, Forum.first)``` the ```Forum``` have one ```Category```, if you want get all moderators of this ```Category``` you can't. This modification make this way possible.

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

    moderator_john.add_scope_role(:moderator, nerd_forum)
    moderator_jane.add_scope_role(:moderator, geek_forum)

For get all moderators of this Category

    User.with_scoped_role :moderator, geek_world, scope: :root

## Bugfix

We have fixed a bug on ```has_role?``` method for object none persisted

## Roadmap

Possible enhancements

Refactoring on root resource API

Change

    class Forum < ActiveRecord::Base
      belongs_to :category

      def root_resource
        :category
      end
    end

to

    class Forum < ActiveRecord::Base
      belongs_to :category
      scoped_roles belongs_to: :category
    end

This way seem pretty nice, but need spend more time on it.

## Contributing

1. Fork it ( http://github.com/<my-github-username>/scoped_rolify/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
