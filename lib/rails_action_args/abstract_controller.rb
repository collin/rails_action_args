# Marking entire api private because I don't want to think about it right now.
module AbstractController
  module ActionArgs
    extend ActiveSupport::Concern
    class BadRequest < StandardError; end
    
    included do
      cattr_accessor :action_argument_list
      extend ClassMethods
      rescue_from(ActionArgs::BadRequest) { render :text => "BadRequest", :status => 400 }
    end
    
    # FIXME: RuntimeError
    # MRI action args gets a [nil] sexp for [ApplicationController, "_rescue_action"]
    # there must be a correct way so that this never happens
    # :api: private
    def send_action(action_name)
      send(action_name, *action_args_for(action_name))
    rescue RuntimeError
      Rails.logger.warn "#{__FILE__}:#{__LINE__} Rescuing RuntimeError in ActionArgs"
      send(action_name)
    end
  
    # :api: private
    def action_args_for(action_name)
      self.class.action_args_for(action_name, params)
    end
    
    module ClassMethods
      # :api: private
      def action_args_for(action_name, params)
        self.action_argument_list ||= {}
        action_argument_list[action_name] ||= extract_action_args_for(action_name)
        arguments, defaults = action_argument_list[action_name]
        
        arguments.map do |arg, default|
          arg = arg
          p = params.key?(arg.to_sym)
          raise BadRequest unless p || (defaults && defaults.include?(arg))
          p ? params[arg.to_sym] : default
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