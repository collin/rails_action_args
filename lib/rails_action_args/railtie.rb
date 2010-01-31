module Rails
  module ActionArgs
    class Railtie < Rails::Railtie
      railtie_name :action_args
      
      config.after_initialize do |app|
        class << ::ActionController::Base
          include Rails::ActionArgs::AbstractControllerMixin
        end
      end
    end
  end
end