require File.dirname(__FILE__) + '/test_helper'

class ActionArgsTest < SimpleRouteCase

  test "should not accidently introduce any methods as controller actions"

  test "should be able to handle a nested class" do
    get "/awesome_action_args/index?foo=bar"

    assert_body "bar"
  end
  
  test "should be able to handle no arguments" do
    get "/action_args/nada"

    assert_body "NADA"
  end
  
  test "should be able to accept Action Arguments" do
    get "/action_args/index?foo=bar"

    assert_body "bar"
  end
  
  test "should be able to accept multiple Action Arguments" do
    get "/action_args/multi?foo=bar&bar=baz"
    
    assert_body "bar baz"    
  end
  
  test "should be able to handle defaults in Action Arguments" do
    get "/action_args/defaults?foo=bar"
    
    assert_body "bar bar"
  end
  
  test "should be able to handle out of order defaults" do
    get "/action_args/defaults_mixed?foo=bar&baz=bar"
    
    assert_body "bar bar bar"
  end
  
  test "should return bad request if the arguments are not provided" do
    get "/action_args/index"
    
    assert_status 400
  end
  
  test "should treat define_method actions as equal" do
    get "/action_args/dynamic_define_method"
    
    assert_body "mos def"
  end
  
  test "should be able to inherit actions for use with Action Arguments" do
    get "/action_args/funky_inherited_method?foo=bar&bar=baz"
    
    assert_body "bar baz"
  end
  
  test "should be able to handle nil defaults" do
    get "/action_args/with_default_nil?foo=bar"
    
    assert_body "bar "
  end
  
end
