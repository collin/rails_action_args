module ExtraActions
  def self.included(base)
    base.show_action(:funky_inherited_method)
  end
  
  def funky_inherited_method(foo, bar)
    "#{foo} #{bar}"
  end
end

class ActionArgsController < ActionController::Base
  include ActionArgs
end

module Awesome
  class ActionArgs < ActionArgsController
    def index(foo)
      foo.to_s
    end
  end
end

class ActionArgs < ActionArgsController
  include ExtraActions

  def nada
    render :string => "NADA"
  end
  
  def index(foo)
    render :string => foo
  end
  
  def multi(foo, bar)
    render :string => "#{foo} #{bar}"
  end
  
  def defaults(foo, bar = "bar")
    render :string => "#{foo} #{bar}"
  end
  
  def defaults_mixed(foo, bar ="bar", baz = "baz")
    render :string => "#{foo} #{bar} #{baz}"
  end
  
  define_method :dynamic_define_method do
    render :string => "mos def"
  end
    
  def with_default_nil(foo, bar = nil)
    render :string => "#{foo} #{bar}"
  end
  
end
