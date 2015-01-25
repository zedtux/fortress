require 'spec_helper'

describe 'Authorisations appending (YourCursus/fortress#7)' do
  describe GuitarsController, type: :controller do
    let(:controller_name) { 'GuitarsController' }
    before { Fortress::Mechanism.initialize_authorisations }
    context 'when calling the first time `fortress_allow` method' do
      before { GuitarsController.fortress_allow [:index, :show] }
      it 'should create a new authorisation for the controller' do
        expect(Fortress::Mechanism.authorisations).to have_key(controller_name)
        expect(Fortress::Mechanism.authorisations[controller_name])
          .to eql(only: [:index, :show])
      end
      context 'when calling a second time `fortress_allow` method' do
        before { GuitarsController.fortress_allow :create, if: :true }
        it 'should append keys to the existing controller authorisation' do
          expect(Fortress::Mechanism.authorisations)
            .to have_key(controller_name)
          expect(Fortress::Mechanism.authorisations[controller_name])
            .to eql(only: [:index, :show],
                    if: { method: :true, actions: [:create] })
        end
      end
    end

    context 'when calling the first time `fortress_allow` method' do
      before { GuitarsController.fortress_allow :all, except: :destroy }
      it 'should create a new authorisation for the controller' do
        expect(Fortress::Mechanism.authorisations).to have_key(controller_name)
        expect(Fortress::Mechanism.authorisations[controller_name])
          .to eql(all: true, except: [:destroy])
      end
      context 'when calling a second time `fortress_allow` method' do
        context 'using the `:if` option with a method returning true' do
          before { GuitarsController.fortress_allow :destroy, if: :true }
          it 'should append keys to the existing controller authorisation' do
            expect(Fortress::Mechanism.authorisations)
              .to have_key(controller_name)
            expect(Fortress::Mechanism.authorisations[controller_name])
              .to eql(all: true, except: [:destroy],
                      if: { method: :true, actions: [:destroy] })
          end
          it 'should allow the controller action' do
            post :destroy, id: 1

            expect(response).to_not redirect_to(root_url)
            expect(flash[:error]).to be_nil
            expect(response).to have_http_status(:ok)
          end
        end
        context 'using the `:if` option with a method returning false' do
          before { GuitarsController.fortress_allow :destroy, if: :false }
          it 'should append keys to the existing controller authorisation' do
            expect(Fortress::Mechanism.authorisations)
              .to have_key(controller_name)
            expect(Fortress::Mechanism.authorisations[controller_name])
              .to eql(all: true, except: [:destroy],
                      if: { method: :false, actions: [:destroy] })
          end
          it 'should prevent the controller action' do
            post :destroy, id: 1

            expect(response).to redirect_to(root_url)
            expect(flash[:error]).to be_present
          end
        end
      end
    end
  end
end
