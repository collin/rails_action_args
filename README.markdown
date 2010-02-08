It's time for action arguments in Rails3.

Big thanks go out to: ezmobius, mattetti, maiha, Yehuda Katz, Andy Delcambre, Janne Asmala. Did I miss any merb-action-args contributors?

# rails_action_args

A plugin for the Rails framework that provides support for arguments to actions that 
come in from the query.

### Install

As a system gem:

    gem install rails_action_args
    
Or in a gemfile:

    gem "rails_action_args", "0.1.5"

When installed as a gem:

    require "rails_action_args/plugin"

Or as a plugin
    
    script/plugin install git://github.com/collin/rails_action_args.git

### Basics

    class Foo < ApplicationController::Base
      def bar(baz)
        bar
      end
    end

Hitting "/foo/bar?baz=bat" will call foo("bat").

Hitting "/foo/bar" will raise an AbstractController::ActionArgs::InvalidActionArgs exception

### Defaults

    class Foo < ApplicationController::Base
      def bar(baz, bat = "hola")
        "#{baz} #{bat}"
      end
    end

Hitting "/foo/bar?baz=bat" will call foo("bat", "hola")

Hitting "/foo/bar?baz=bat&bat=whaa" will call foo("bat", "whaa")

Hitting "/foo/bar" will still raise a BadRequest.

#### Out of order defaults

    class Foo < ApplicationController::Base
      def bar(one, two = "dos", three = "tres")
        "#{one} #{two} #{three}"
      end
    end

The interesting thing here is that hitting "/foo/bar?one=uno&three=three" will call
foo("uno", "dos", "three"). In other words, the defaults can be in any order, and 
rails_action_args will figure out where to fill in the holes.
