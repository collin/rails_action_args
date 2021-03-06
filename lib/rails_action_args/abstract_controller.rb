require 'rails_action_args/get_args'
# Marking entire api private because I don't want to think about it right now.
module AbstractController
  module ActionArgs
    extend ActiveSupport::Concern
    class InvalidActionArgs < StandardError; end
    
    included do
      cattr_accessor :action_argument_list
      extend ClassMethods
    end
    
    def send_action(action_name)
      send(action_name, *action_args_for(action_name))
    end
  
    # :api: private
    def action_args_for(action_name)
      self.class.action_args_for(action_name, params)
    end
    
    module ClassMethods
      # :api: private
      def action_args_for(action_name, params)
        arguments, defaults = extract_action_args_for(action_name)
        
        arguments.map do |arg, default|
          arg = arg
          param = params.key?(arg.to_sym)
          unless param || (defaults && defaults.include?(arg))
            raise InvalidActionArgs.new("No value or default value supplied for action arg: #{arg}")
          else
            param ? params[arg.to_sym] : default
          end
        end
      end
      
      # :api: private
      def extract_action_args_for(action_name)
        args = instance_method(action_name).get_args
        arguments = args[0]
        defaults = []
        arguments.each {|a| defaults << a[0] if a.size == 2} if arguments
        [arguments || [], defaults]
      end
    end
  end
end