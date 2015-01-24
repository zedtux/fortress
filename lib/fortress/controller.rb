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
      respond_to do |format|
        format.html { redirect_to_root_url_with_flash_message }
        format.json { unauthorized_with_error_message(:json) }
        format.xml { unauthorized_with_error_message(:xml) }
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

    private

    def error_message
      'You are not authorised to access this page.'
    end

    def redirect_to_root_url_with_flash_message
      flash[:error] = error_message
      redirect_to root_url
    end

    def unauthorized_with_error_message(format)
      self.status = :unauthorized
      self.response_body = response_for_format(format)
    end

    def response_for_format(format)
      response = { error: error_message }
      case
      when format == :json then response.to_json
      when format == :xml then response.to_xml
      end
    end
  end
end
