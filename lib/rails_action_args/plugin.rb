require 'rails'
module Rails
  module ActionArgs
    class Plugin < Rails::Plugin
      plugin_name :action_args
      
      config.after_initialize do |app|
        class << ::ActionController::Base
          include Rails::ActionArgs::AbstractControllerMixin
        end
      end
    end
  end
end