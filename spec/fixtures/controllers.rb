require 'fortress'

#
# Mother class for all controller used to test Fortress
#
class TestController < ActionController::Base
  include Rails.application.routes.url_helpers
  def render(*_)
  end
end

#
# This controller is the one used in all the tests
#
class GuitarsController < TestController
  def index; end

  def show; end

  def new; end

  def create; end

  def edit; end

  def update; end

  def destroy; end

  private

  def true
    true
  end

  def false
    false
  end
end

#
# Controller with a custom access_deny method
#
class ConcertsController < TestController
  def index; end

  def access_deny
    flash[:error] = 'Accès refusé'
    redirect_to '/another/route'
  end
end
