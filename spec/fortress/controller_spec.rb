require 'spec_helper'

describe GuitarsController, type: :controller do
  it 'should have a before filter `:prevent_access!`' do
    before_filters = subject._process_action_callbacks.map do |callback|
      callback.filter if callback.kind == :before
    end.compact

    expect(before_filters).to include(:prevent_access!)
  end

  context 'without allowing any actions' do
    before { Fortress::Mechanism.initialize_authorisations }
    describe 'GET index' do
      it 'should redirect to the root_url and set a flash error message' do
        get :index

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'GET show' do
      it 'should redirect to the root_url and set a flash error message' do
        get :show, id: 1

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'GET new' do
      it 'should redirect to the root_url and set a flash error message' do
        get :new

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'POST create' do
      it 'should redirect to the root_url and set a flash error message' do
        post :create

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'GET edit' do
      it 'should redirect to the root_url and set a flash error message' do
        post :edit, id: 1

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'PUT update' do
      it 'should redirect to the root_url and set a flash error message' do
        put :update, id: 1

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'PATCH update' do
      it 'should redirect to the root_url and set a flash error message' do
        patch :update, id: 1

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'POST destroy' do
      it 'should redirect to the root_url and set a flash error message' do
        post :destroy, id: 1

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
  end

  context 'allowing the index action only' do
    before do
      Fortress::Mechanism.initialize_authorisations
      GuitarsController.fortress_allow :index
    end
    describe 'GET index' do
      it 'should return a 200 HTTP code' do
        get :index

        expect(response).to_not redirect_to(root_url)
        expect(flash[:error]).to be_nil
        expect(response).to have_http_status(:ok)
      end
    end
    describe 'GET show' do
      it 'should redirect to the root_url and set a flash error message' do
        get :show, id: 1

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'GET new' do
      it 'should redirect to the root_url and set a flash error message' do
        get :new

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'POST create' do
      it 'should redirect to the root_url and set a flash error message' do
        post :create

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'GET edit' do
      it 'should redirect to the root_url and set a flash error message' do
        post :edit, id: 1

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'PUT update' do
      it 'should redirect to the root_url and set a flash error message' do
        put :update, id: 1

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'PATCH update' do
      it 'should redirect to the root_url and set a flash error message' do
        patch :update, id: 1

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'POST destroy' do
      it 'should redirect to the root_url and set a flash error message' do
        post :destroy, id: 1

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
  end

  context 'allowing the index and show (using an Array) action only' do
    before do
      Fortress::Mechanism.initialize_authorisations
      GuitarsController.fortress_allow [:index, :show]
    end
    describe 'GET index' do
      it 'should return a 200 HTTP code' do
        get :index

        expect(response).to_not redirect_to(root_url)
        expect(flash[:error]).to be_nil
        expect(response).to have_http_status(:ok)
      end
    end
    describe 'GET show' do
      it 'should redirect to the root_url and set a flash error message' do
        get :show, id: 1

        expect(response).to_not be_redirect
        expect(flash[:error]).to be_nil
        expect(response).to have_http_status(:ok)
      end
    end
    describe 'GET new' do
      it 'should redirect to the root_url and set a flash error message' do
        get :new

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'POST create' do
      it 'should redirect to the root_url and set a flash error message' do
        post :create

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'GET edit' do
      it 'should redirect to the root_url and set a flash error message' do
        post :edit, id: 1

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'PUT update' do
      it 'should redirect to the root_url and set a flash error message' do
        put :update, id: 1

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'PATCH update' do
      it 'should redirect to the root_url and set a flash error message' do
        patch :update, id: 1

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'POST destroy' do
      it 'should redirect to the root_url and set a flash error message' do
        post :destroy, id: 1

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
  end

  context 'allowing all actions using `:all`' do
    before do
      Fortress::Mechanism.initialize_authorisations
      GuitarsController.fortress_allow :all
    end
    describe 'GET index' do
      it 'should return a 200 HTTP code' do
        get :index

        expect(response).to_not redirect_to(root_url)
        expect(flash[:error]).to be_nil
        expect(response).to have_http_status(:ok)
      end
    end
    describe 'GET show' do
      it 'should return a 200 HTTP code' do
        get :show, id: 1

        expect(response).to_not be_redirect
        expect(flash[:error]).to be_nil
        expect(response).to have_http_status(:ok)
      end
    end
    describe 'GET new' do
      it 'should return a 200 HTTP code' do
        get :new

        expect(response).to_not redirect_to(root_url)
        expect(flash[:error]).to be_nil
        expect(response).to have_http_status(:ok)
      end
    end
    describe 'POST create' do
      it 'should return a 200 HTTP code' do
        post :create

        expect(response).to_not redirect_to(root_url)
        expect(flash[:error]).to be_nil
        expect(response).to have_http_status(:ok)
      end
    end
    describe 'GET edit' do
      it 'should return a 200 HTTP code' do
        post :edit, id: 1

        expect(response).to_not redirect_to(root_url)
        expect(flash[:error]).to be_nil
        expect(response).to have_http_status(:ok)
      end
    end
    describe 'PUT update' do
      it 'should return a 200 HTTP code' do
        put :update, id: 1

        expect(response).to_not redirect_to(root_url)
        expect(flash[:error]).to be_nil
        expect(response).to have_http_status(:ok)
      end
    end
    describe 'PATCH update' do
      it 'should return a 200 HTTP code' do
        patch :update, id: 1

        expect(response).to_not redirect_to(root_url)
        expect(flash[:error]).to be_nil
        expect(response).to have_http_status(:ok)
      end
    end
    describe 'POST destroy' do
      it 'should return a 200 HTTP code' do
        post :destroy, id: 1

        expect(response).to_not redirect_to(root_url)
        expect(flash[:error]).to be_nil
        expect(response).to have_http_status(:ok)
      end
    end
  end

  context 'allowing all actions excepted the create action' do
    before do
      Fortress::Mechanism.initialize_authorisations
      GuitarsController.fortress_allow :all, except: :create
    end
    describe 'GET index' do
      it 'should return a 200 HTTP code' do
        get :index

        expect(response).to_not redirect_to(root_url)
        expect(flash[:error]).to be_nil
        expect(response).to have_http_status(:ok)
      end
    end
    describe 'GET show' do
      it 'should return a 200 HTTP code' do
        get :show, id: 1

        expect(response).to_not redirect_to(root_url)
        expect(flash[:error]).to be_nil
        expect(response).to have_http_status(:ok)
      end
    end
    describe 'GET new' do
      it 'should return a 200 HTTP code' do
        get :new

        expect(response).to_not redirect_to(root_url)
        expect(flash[:error]).to be_nil
        expect(response).to have_http_status(:ok)
      end
    end
    describe 'POST create' do
      it 'should redirect to the root_url and set a flash error message' do
        post :create

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'GET edit' do
      it 'should return a 200 HTTP code' do
        post :edit, id: 1

        expect(response).to_not redirect_to(root_url)
        expect(flash[:error]).to be_nil
        expect(response).to have_http_status(:ok)
      end
    end
    describe 'PUT update' do
      it 'should return a 200 HTTP code' do
        put :update, id: 1

        expect(response).to_not redirect_to(root_url)
        expect(flash[:error]).to be_nil
        expect(response).to have_http_status(:ok)
      end
    end
    describe 'PATCH update' do
      it 'should return a 200 HTTP code' do
        patch :update, id: 1

        expect(response).to_not redirect_to(root_url)
        expect(flash[:error]).to be_nil
        expect(response).to have_http_status(:ok)
      end
    end
    describe 'POST destroy' do
      it 'should return a 200 HTTP code' do
        post :destroy, id: 1

        expect(response).to_not redirect_to(root_url)
        expect(flash[:error]).to be_nil
        expect(response).to have_http_status(:ok)
      end
    end
  end

  context 'allowing the index action with a condition returning true' do
    before do
      Fortress::Mechanism.initialize_authorisations
      GuitarsController.fortress_allow :index, if: :true
    end
    describe 'GET index' do
      it 'should return a 200 HTTP code' do
        get :index

        expect(response).to_not redirect_to(root_url)
        expect(flash[:error]).to be_nil
        expect(response).to have_http_status(:ok)
      end
    end
    describe 'GET show' do
      it 'should redirect to the root_url and set a flash error message' do
        get :show, id: 1

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'GET new' do
      it 'should redirect to the root_url and set a flash error message' do
        get :new

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'POST create' do
      it 'should redirect to the root_url and set a flash error message' do
        post :create

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'GET edit' do
      it 'should redirect to the root_url and set a flash error message' do
        post :edit, id: 1

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'PUT update' do
      it 'should redirect to the root_url and set a flash error message' do
        put :update, id: 1

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'PATCH update' do
      it 'should redirect to the root_url and set a flash error message' do
        patch :update, id: 1

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'POST destroy' do
      it 'should redirect to the root_url and set a flash error message' do
        post :destroy, id: 1

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
  end

  context 'allowing the index action with a condition returning false' do
    before do
      Fortress::Mechanism.initialize_authorisations
      GuitarsController.fortress_allow :index, if: :false
    end
    describe 'GET index' do
      it 'should redirect to the root_url and set a flash error message' do
        get :index

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'GET show' do
      it 'should redirect to the root_url and set a flash error message' do
        get :show, id: 1

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'GET new' do
      it 'should redirect to the root_url and set a flash error message' do
        get :new

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'POST create' do
      it 'should redirect to the root_url and set a flash error message' do
        post :create

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'GET edit' do
      it 'should redirect to the root_url and set a flash error message' do
        post :edit, id: 1

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'PUT update' do
      it 'should redirect to the root_url and set a flash error message' do
        put :update, id: 1

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'PATCH update' do
      it 'should redirect to the root_url and set a flash error message' do
        patch :update, id: 1

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
    describe 'POST destroy' do
      it 'should redirect to the root_url and set a flash error message' do
        post :destroy, id: 1

        expect(response).to redirect_to(root_url)
        expect(flash[:error]).to be_present
      end
    end
  end
end
