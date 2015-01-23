require 'spec_helper'

class ConcertsController < TestController
  def index; end

  def access_deny
    flash[:error] = 'Accès refusé'
    redirect_to '/another/route'
  end
end

describe GuitarsController, type: :controller do
  describe 'access_deny' do
    it 'should have a default method' do
      default_message = 'You are not authorised to access this page.'

      get :index

      expect(response).to redirect_to(root_url)
      expect(flash[:error]).to eql(default_message)
    end
  end
end

describe ConcertsController, type: :controller do
  describe 'access_deny' do
    it 'flash message should be overriden' do
      new_message = 'Accès refusé'

      get :index

      expect(flash[:error]).to eql(new_message)
    end
    it 'redirection should be overriden' do
      new_route = '/another/route'

      get :index

      expect(response).to redirect_to(new_route)
    end
  end
end
