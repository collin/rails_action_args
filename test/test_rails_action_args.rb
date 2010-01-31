require 'test/unit'
require 'shoulda'
require 'rack/test'
require 'action_controller'
require 'active_support/all'
require 'rails_action_args'

module ExtraActions
  def funky_inherited_method(foo, bar)
    "#{foo} #{bar}"
  end
end
 
module Awesome
  class NestedActionArgsController < ActionController::Base
    include AbstractController::ActionArgs
    def index(foo)
      foo.to_s
    end
  end
end
 
class ActionArgsController < ActionController::Base
  include AbstractController::ActionArgs
  include ExtraActions
 
  def nada
    render :text => "NADA"
  end
  
  def index(foo)
    render :text => foo
  end
  
  def multi(foo, bar)
    render :text => "#{foo} #{bar}"
  end
  
  def defaults(foo, bar = "bar")
    render :text => "#{foo} #{bar}"
  end
  
  def defaults_mixed(foo, bar ="bar", baz = "baz")
    render :text => "#{foo} #{bar} #{baz}"
  end
  
  define_method :dynamic_define_method do
    render :text => "mos def"
  end
    
  def with_default_nil(foo, bar = nil)
    render :text => "#{foo} #{bar}"
  end
  
end

ActionController::Routing::Routes.draw do |map|
  map.connect ':controller/:action/:id'
end

class ActionArgsTest < Test::Unit::TestCase
  include Rack::Test::Methods
  # test "test_not_accidently_introduce_any_methods_as_controller_actions"
  
  def app
    Rack::URLMap.new \
      '/awesome_nested_action_args/index'     => Awesome::NestedActionArgsController.action(:index),
      '/action_args/nada'                     => ActionArgsController.action(:nada),
      '/action_args/index'                    => ActionArgsController.action(:index),
      '/action_args/multi'                    => ActionArgsController.action(:multi),
      '/action_args/defaults'                 => ActionArgsController.action(:defaults),
      '/action_args/defaults_mixed'           => ActionArgsController.action(:defaults_mixed),
      '/action_args/dynamic_define_method'    => ActionArgsController.action(:dynamic_define_method),
      '/action_args/funky_inherited_method'   => ActionArgsController.action(:funky_inherited_method),
      '/action_args/with_default_nil'         => ActionArgsController.action(:with_default_nil)
  end
  
  def test_handle_a_nested_class
    get "/awesome_nested_action_args/index?foo=bar"
    assert_equal "bar", last_response.body
  end
  
  def test_handle_no_arguments
    get "/action_args/nada"
    assert_equal "NADA", last_response.body
  end
  
  def test_accept_action_arguments
    get "/action_args/index?foo=bar"
    assert_equal "bar", last_response.body
  end
  
  def test_accept_multiple_action_arguments
    get "/action_args/multi?foo=bar&bar=baz"
    assert_equal "bar baz", last_response.body
  end
  
  def test_handle_defaults_in_action_arguments
    get "/action_args/defaults?foo=bar"
    assert_equal "bar bar", last_response.body
  end
  
  def test_handle_out_of_order_defaults
    get "/action_args/defaults_mixed?foo=bar&baz=bar"    
    assert_equal "bar bar bar", last_response.body
  end
  
  def test_return_bad_request_if_the_arguments_are_not_provided
    assert_raise(AbstractController::ActionArgs::InvalidActionArgs) do
      get "/action_args/index"
    end
  end
  
  def test_treat_define_method_actions_as_equal
    get "/action_args/dynamic_define_method"
    assert_equal "mos def", last_response.body
  end
  
  def test_inherit_actions_for_use_with_action_arguments
    get "/action_args/funky_inherited_method?foo=bar&bar=baz"
    assert_equal "bar baz", last_response.body
  end
  
  def test_handle_nil_defaults
    get "/action_args/with_default_nil?foo=bar"
    assert_equal "bar ", last_response.body
  end
end
