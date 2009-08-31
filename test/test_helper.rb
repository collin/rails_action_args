$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require "../actionpack/test/new_base/test_helper"
require "rails-action-args"
require File.dirname(__FILE__) + "/controllers/action-args"
begin
  require 'ruby-debug'
  Debugger.settings[:autoeval] = true
  Debugger.start
rescue LoadError
  # Debugging disabled. `gem install ruby-debug` to enable.
end

