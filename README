Not working yet, but close :) Four failing tests.

rails-action-args
================

A plugin for the Rails framework that provides support for arguments to actions that 
come in from the query.

==== Basics

{{[
class Foo < ApplicationController::Base
  def bar(baz)
    bar
  end
end
]}}

Hitting "/foo/bar?baz=bat" will call foo("bat").

Hitting "/foo/bar" will raise a BadRequest (Status 400) error.

==== Defaults

{{[
class Foo < ApplicationController::Base
  include AbstractController::ActionArgs
  def bar(baz, bat = "hola")
    "#{baz} #{bat}"
  end
end
]}}

Hitting "/foo/bar?baz=bat" will call foo("bat", "hola")

Hitting "/foo/bar?baz=bat&bat=whaa" will call foo("bat", "whaa")

Hitting "/foo/bar" will still raise a BadRequest.

==== Out of order defaults

{{[
class Foo < ApplicationController::Base
  include AbstractController::ActionArgs
  def bar(one, two = "dos", three = "tres")
    "#{one} #{two} #{three}"
  end
end
]}}

The interesting thing here is that hitting "/foo/bar?one=uno&three=three" will call
foo("uno", "dos", "three"). In other words, the defaults can be in any order, and 
rails-action-args will figure out where to fill in the holes.
