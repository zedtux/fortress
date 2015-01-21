require 'spec_helper'
require 'fortress/controller_interface'

describe Fortress::ControllerInterface do
  before do
    Fortress::Mechanism.initialize_authorisations
    @controller = GuitarsController.new
  end

  describe '.blocked?' do
    context 'when controller is unknown from the Fortress::Mechanism module' do
      subject { Fortress::ControllerInterface.new(@controller) }
      it 'should return true' do
        expect(subject.blocked?).to be_truthy
      end
    end
    context 'when controller is known from the Fortress::Mechanism module' do
      before do
        Fortress::Mechanism.authorisations['GuitarsController'] = { all: true }
      end
      subject { Fortress::ControllerInterface.new(@controller) }
      it 'should return false' do
        expect(subject.blocked?).to be_falsy
      end
    end
  end

  describe '.allow_all?' do
    context 'when controller has the `:all` key to true in the ' \
            'Fortress::Mechanism module' do
      before do
        Fortress::Mechanism.authorisations['GuitarsController'] = { all: true }
      end
      subject { Fortress::ControllerInterface.new(@controller) }
      it 'should return true' do
        expect(subject.allow_all?).to be_truthy
      end
    end
    context 'when controller doesn\'t have the `:all` key to true in the ' \
            'Fortress::Mechanism module' do
      before do
        Fortress::Mechanism.authorisations['GuitarsController'] = {}
      end
      before { Fortress::Mechanism.authorise!('GuitarsController', :index) }
      subject { Fortress::ControllerInterface.new(@controller) }
      it 'should return false' do
        expect(subject.allow_all?).to be_falsy
      end
    end
  end

  describe '.allow_all_without_except?' do
    context 'when controller has the `:all` key to true in the ' \
            'Fortress::Mechanism module and doesn\'t have the `:except` key' do
      before do
        Fortress::Mechanism.authorisations['GuitarsController'] = { all: true }
      end
      subject { Fortress::ControllerInterface.new(@controller) }
      it 'should return true' do
        expect(subject.allow_all_without_except?).to be_truthy
      end
    end
    context 'when controller has the `:all` key to true in the ' \
            'Fortress::Mechanism module and do have the `:except` key' do
      before do
        Fortress::Mechanism.authorisations['GuitarsController'] = {
          all: true, except: [:index]
        }
      end
      subject { Fortress::ControllerInterface.new(@controller) }
      it 'should return false' do
        expect(subject.allow_all_without_except?).to be_falsy
      end
    end
  end

  describe '.allow_action?' do
    describe 'passing `:index` as parameter' do
      context 'when the controller has the `:except` key containing `:index` ' \
              'in the Fortress::Mechanism module' do
        before do
          Fortress::Mechanism.authorisations['GuitarsController'] = {
            except: :index
          }
        end
        subject { Fortress::ControllerInterface.new(@controller) }
        it 'should return false' do
          expect(subject.allow_action?(:index)).to be_falsy
        end
      end
      context 'when the controller has the `:except` key which doesn\'t ' \
              'contain the `:index` action in the Fortress::Mechanism module' do
        context 'and the controller has the `:if` key with `:action` ' \
                'including `:index`' do
          context 'the `:method` return false' do
            before do
              Fortress::Mechanism.authorisations['GuitarsController'] = {
                if: { actions: [:index], method: false }
              }
            end
            subject { Fortress::ControllerInterface.new(@controller) }
            it 'should return false' do
              expect(subject.allow_action?(:index)).to be_falsy
            end
          end
          context 'the `:method` return true' do
            before do
              Fortress::Mechanism.authorisations['GuitarsController'] = {
                if: { actions: [:index], method: true }
              }
            end
            subject { Fortress::ControllerInterface.new(@controller) }
            it 'should return true' do
              expect(subject.allow_action?(:index)).to be_truthy
            end
          end
        end
        context 'and the controller has the `:if` key with `:action` ' \
                'which doesn\'t includ the `:index` action' do
          context 'and the controller has the `:only` key' do
            context 'which do include `:index`' do
              before do
                Fortress::Mechanism.authorisations['GuitarsController'] = {
                  only: [:index]
                }
              end
              subject { Fortress::ControllerInterface.new(@controller) }
              it 'should return true' do
                expect(subject.allow_action?(:index)).to be_truthy
              end
            end
            context 'which do not include `:index`' do
              before do
                Fortress::Mechanism.authorisations['GuitarsController'] = {
                  only: [:update]
                }
              end
              subject { Fortress::ControllerInterface.new(@controller) }
              it 'should return false' do
                expect(subject.allow_action?(:index)).to be_falsy
              end
            end
          end
          context 'and the controller hasn\'t the `:only` key' do
            context 'and the controller has the `:all` key' do
              before do
                Fortress::Mechanism.authorisations['GuitarsController'] = {
                  only: [], except: [], all: true
                }
              end
              subject { Fortress::ControllerInterface.new(@controller) }
              it 'should return true' do
                expect(subject.allow_action?(:index)).to be_truthy
              end
            end
            context 'and the controller do not have the `:all` key' do
              before do
                Fortress::Mechanism.authorisations['GuitarsController'] = {
                  only: [], except: []
                }
              end
              subject { Fortress::ControllerInterface.new(@controller) }
              it 'should return false' do
                expect(subject.allow_action?(:index)).to be_falsy
              end
            end
          end
        end
      end
    end
  end

  describe '.allow_method?' do
    context 'when controller do have a `:if` key but no `:method` key in ' \
            'the Fortress::Mechanism' do
      before do
        Fortress::Mechanism.authorisations['GuitarsController'] = { if: {} }
      end
      subject { Fortress::ControllerInterface.new(@controller) }
      it 'should return false' do
        expect(subject.allow_method?).to be_falsy
      end
    end
    context 'when controller do have a `:if` key and a `:method` key in ' \
            'the Fortress::Mechanism' do
      before do
        Fortress::Mechanism.authorisations['GuitarsController'] = {
          if: { method: :test }
        }
      end
      subject { Fortress::ControllerInterface.new(@controller) }
      it 'should return true' do
        expect(subject.allow_method?).to be_truthy
      end
    end
  end

  describe '.needs_to_check_action?' do
    describe 'passing `:index` as parameter' do
      context 'when controller do not have the `:if` key in ' \
              'the Fortress::Mechanism' do
        before do
          Fortress::Mechanism.authorisations['GuitarsController'] = {}
        end
        subject { Fortress::ControllerInterface.new(@controller) }
        it 'should return false' do
          expect(subject.needs_to_check_action?(:index)).to be_falsy
        end
      end
      context 'when controller do have the `:if` key in ' \
              'the Fortress::Mechanism without the `actions` key' do
        before do
          Fortress::Mechanism.authorisations['GuitarsController'] = {
            if: { method: :is_admin? }
          }
        end
        subject { Fortress::ControllerInterface.new(@controller) }
        it 'should return false' do
          expect(subject.needs_to_check_action?(:index)).to be_falsy
        end
      end
      context 'when controller do have the `:if` key in ' \
              'the Fortress::Mechanism and the `actions` key ' \
              'containing :update' do
        before do
          Fortress::Mechanism.authorisations['GuitarsController'] = {
            if: { actions: :update }
          }
        end
        subject { Fortress::ControllerInterface.new(@controller) }
        it 'should return false' do
          expect(subject.needs_to_check_action?(:index)).to be_falsy
        end
      end
      context 'when controller do have the `:if` key in ' \
              'the Fortress::Mechanism and the `actions` key ' \
              'containing :index' do
        before do
          Fortress::Mechanism.authorisations['GuitarsController'] = {
            if: { actions: :index }
          }
        end
        subject { Fortress::ControllerInterface.new(@controller) }
        it 'should return true' do
          expect(subject.needs_to_check_action?(:index)).to be_truthy
        end
      end
    end
  end
end
