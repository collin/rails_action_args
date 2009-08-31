require 'rails/actionpack/test/abstract_unit'

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

class ActionArgsTest < ActionController::IntegrationTest
  # test "test_not_accidently_introduce_any_methods_as_controller_actions"
  
  def test_handle_a_nested_class
    get "/awesome_nested_action_args/index?foo=bar"
    assert body == "bar"
  end
  
  def test_handle_no_arguments
    get "/action_args/nada"
    assert body == "NADA"
  end
  
  def test_accept_action_arguments
    get "/action_args/index?foo=bar"
    assert body == "bar"
  end
  
  def test_accept_multiple_action_arguments
    get "/action_args/multi?foo=bar&bar=baz"
    assert body == "bar baz"
  end
  
  def test_handle_defaults_in_action_arguments
    get "/action_args/defaults?foo=bar"
    assert body == "bar bar"
  end
  
  def test_handle_out_of_order_defaults
    get "/action_args/defaults_mixed?foo=bar&baz=bar"    
    assert body == "bar bar bar"
  end
  
  def test_return_bad_request_if_the_arguments_are_not_provided
    get "/action_args/index"
    assert status == 400
  end
  
  def test_treat_define_method_actions_as_equal
    get "/action_args/dynamic_define_method"
    assert body == "mos def"
  end
  
  def test_inherit_actions_for_use_with_action_arguments
    get "/action_args/funky_inherited_method?foo=bar&bar=baz"
    assert body == "bar baz"
  end
  
  def test_handle_nil_defaults
    get "/action_args/with_default_nil?foo=bar"
    assert body == "bar "
  end
end