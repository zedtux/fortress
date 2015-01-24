require 'active_support/all'
require 'action_controller'
require 'action_dispatch'

#
# Re-define the Rails module
#
module Rails
  #
  # Fake Rails application
  #
  class App
    def env_config
      {}
    end

    def routes
      return @routes if defined?(@routes)
      @routes = ActionDispatch::Routing::RouteSet.new
      @routes.draw do
        root 'home#index'
        resources :guitars
        resources :concerts
        # Represents an external controller
        resources :stages
      end
      @routes
    end
  end

  def self.application
    @app ||= App.new
  end
end

Rails.application.routes.default_url_options[:host] = 'http://test.host'
