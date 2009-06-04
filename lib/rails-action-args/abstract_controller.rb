# Marking entire api private because I don't want to think about it right now.
module AbstractController
  module ActionArgs
    class BadRequest < StandardError; end
    
    class << self
      attr_accessor :action_argument_list
    end
    
    # :api: private
    def send_action(action_name)
      super(action_name, *action_args_for(action_name))
    end
  
    # :api: private
    def action_args_for(action_name)
      self.class.action_args_for(action_name, params)
    end  
    
    # :api: private
    def self.action_args_for(action_name, params)
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
    def self.extract_action_args_for(action_name)
      args = instance_method(action_name).get_args
      arguments = args[0]
      defaults = []
      arguments.each {|a| defaults << a[0] if a.size == 2} if arguments
      [arguments || [], defaults]
    end
  end
end

