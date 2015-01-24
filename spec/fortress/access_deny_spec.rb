require 'spec_helper'

describe GuitarsController, type: :controller do
  let(:default_message) { 'You are not authorised to access this page.' }
  describe 'access_deny' do
    it 'should have a default method' do
      get :index

      expect(response).to redirect_to(root_url)
      expect(flash[:error]).to eql(default_message)
    end
    describe 'respond with the same format (YourCursus/fortress#2)' do
      context 'with JSON' do
        it 'should respond with a JSON message' do
          json = { error: default_message }.to_json

          get :index, format: :json

          expect(response.status).to eql(401)
          expect(response.body).to eql(json)
        end
      end
      context 'with XML' do
        it 'should respond with a XML message' do
          xml = { error: default_message }.to_xml

          get :index, format: :xml

          expect(response.status).to eql(401)
          expect(response.body).to eql(xml)
        end
      end
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
