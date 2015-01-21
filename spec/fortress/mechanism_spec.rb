require 'spec_helper'
require 'fortress/mechanism'

describe Fortress::Mechanism do
  before { @controller = OpenStruct.new(name: 'ConcertsController') }
  describe '.parse_options' do
    context 'passing the `:if` option' do
      context 'with the `:index` action only' do
        it 'should add the `:if` key to the controller key with ' \
           'the `:action` Array [:index]' do
          subject.parse_options(@controller, :index, if: :method_name)

          controller_if = subject.authorisations['ConcertsController'][:if]
          expect(controller_if).to be_present

          expect(controller_if[:actions]).to eql([:index])
        end
      end
      context 'with actions `:index, :show, :destroy`' do
        it 'should add the `:if` key to the controller key with ' \
           'the `:action` Array [:index, :show, :destroy]' do
          subject.parse_options(@controller, [:index, :show, :destroy],
                                if: :method_name)

          controller_if = subject.authorisations['ConcertsController'][:if]
          expect(controller_if).to be_present

          expect(controller_if[:actions]).to eql([:index, :show, :destroy])
        end
      end
    end
    context 'passing the `:except` option' do
      context 'with `:index` action only' do
        it 'should add the `:except` key to the controller key with ' \
           'the `:action` Array [:index]' do
          subject.parse_options(@controller, nil, except: :index)

          excepted = subject.authorisations['ConcertsController'][:except]
          expect(excepted).to eql([:index])
        end
      end
      context 'with `:index, :new, :update` actions' do
        it 'should add the `:except` key to the controller key with ' \
           'the `:action` Array [:index, :new, :update]' do
          subject.parse_options(@controller, nil,
                                except: [:index, :new, :update])

          excepted = subject.authorisations['ConcertsController'][:except]
          expect(excepted).to eql([:index, :new, :update])
        end
      end
    end
  end
  describe '.authorise!' do
    context 'passing `:all`' do
      it 'should add the `:all` key as true to the controller key' do
        subject.authorise!('ConcertsController', :all)

        expect(subject.authorisations['ConcertsController'][:all]).to be_truthy
      end
    end
    context 'passing `:index`' do
      it 'should add the `:only` key as the Array [:index] to ' \
         'the controller key' do
        subject.authorise!('ConcertsController', :index)

        controller_only = subject.authorisations['ConcertsController'][:only]
        expect(controller_only).to eql([:index])
      end
    end
    context 'passing `[:index, :destroy]`' do
      it 'should add the `:only` key as the Array [:index] to ' \
         'the controller key' do
        subject.authorise!('ConcertsController', [:index, :destroy])

        controller_only = subject.authorisations['ConcertsController'][:only]
        expect(controller_only).to eql([:index, :destroy])
      end
    end
  end
end
