require 'active_support/concern'

module Fortress
  #
  # The Controller module embbed all the code to "hook" Fortress to your Rails
  # application.
  #
  # @author zedtux
  #
  module Controller
    extend ActiveSupport::Concern

    included do
      Mechanism.initialize_authorisations

      # Add a new before_filter for all controllers
      append_before_filter :prevent_access!
    end

    def prevent_access!
      controller = Fortress::ControllerInterface.new(self)
      Mechanism.authorised?(controller, action_name) ? true : access_deny
    end

    #
    # Default access_deny method used when not re-defined in the Rails
    # application.
    #
    # You can re-define it within the ApplicationController of you rails
    # application.
    def access_deny
      message = 'You are not authorised to access this page.'
      respond_to do |format|
        format.html do
          flash[:error] = message
          redirect_to root_url
        end
        format.json do
          self.status = :unauthorized
          self.response_body = { error: message }.to_json
        end
        format.xml do
          self.status = :unauthorized
          self.response_body = { error: message }.to_xml
        end
      end
    end

    #
    # Class methods added to all controllers in a Rails application.
    #
    # @author zedtux
    #
    module ClassMethods
      def fortress_allow(actions, options = {})
        Mechanism.authorise!(name, actions)
        Mechanism.parse_options(self, actions, options) if options.present?
      end
    end
  end
end
