require 'rails_action_args'
class ActionController::Base
  include AbstractController::ActionArgs
end