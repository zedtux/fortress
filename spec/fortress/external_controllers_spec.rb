require 'spec_helper'

class StagesController < TestController
  def index; end

  def show; end

  def new; end

  def create; end

  def edit; end

  def update; end

  def destroy; end
end

describe 'Allow adding manually controller names (YourCursus/fortress#3)' do
  describe StagesController, type: :controller do
    describe 'giving a controller name to config.externals' do
      before do
        Fortress.configure { |config| config.externals = 'StagesController' }
      end
      it 'should allow the index controller action' do
        get :index

        expect(response).to_not redirect_to(root_url)
        expect(flash[:error]).to be_nil
        expect(response).to have_http_status(:ok)
      end
      it 'should allow the show controller action' do
        get :show, id: 1

        expect(response).to_not redirect_to(root_url)
        expect(flash[:error]).to be_nil
        expect(response).to have_http_status(:ok)
      end
      it 'should allow the new controller action' do
        get :new

        expect(response).to_not redirect_to(root_url)
        expect(flash[:error]).to be_nil
        expect(response).to have_http_status(:ok)
      end
      it 'should allow the create controller action' do
        post :create

        expect(response).to_not redirect_to(root_url)
        expect(flash[:error]).to be_nil
        expect(response).to have_http_status(:ok)
      end
      it 'should allow the edit controller action' do
        get :edit, id: 1

        expect(response).to_not redirect_to(root_url)
        expect(flash[:error]).to be_nil
        expect(response).to have_http_status(:ok)
      end
      it 'should allow the update (PUT) controller action' do
        put :update, id: 1

        expect(response).to_not redirect_to(root_url)
        expect(flash[:error]).to be_nil
        expect(response).to have_http_status(:ok)
      end
      it 'should allow the update (PATCH) controller action' do
        patch :update, id: 1

        expect(response).to_not redirect_to(root_url)
        expect(flash[:error]).to be_nil
        expect(response).to have_http_status(:ok)
      end
      it 'should allow the destroy controller action' do
        post :destroy, id: 1

        expect(response).to_not redirect_to(root_url)
        expect(flash[:error]).to be_nil
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
