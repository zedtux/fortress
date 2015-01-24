require 'spec_helper'

describe 'Authorisations appending (YourCursus/fortress#7)' do
  describe GuitarsController, type: :controller do
    let(:controller) { 'GuitarsController' }
    before { Fortress::Mechanism.initialize_authorisations }
    context 'when calling the first time `fortress_allow` method' do
      before { GuitarsController.fortress_allow [:index, :show] }
      it 'should create a new authorisation for the controller' do
        expect(Fortress::Mechanism.authorisations).to have_key(controller)
        expect(Fortress::Mechanism.authorisations[controller])
          .to eql(only: [:index, :show])
      end
      context 'when calling a second time `fortress_allow` method' do
        before { GuitarsController.fortress_allow :create, if: true }
        it 'should append keys to the existing controller authorisation' do
          expect(Fortress::Mechanism.authorisations).to have_key(controller)
          expect(Fortress::Mechanism.authorisations[controller])
            .to eql(only: [:index, :show],
                    if: { method: true, actions: [:create] })
        end
      end
    end
  end
end
