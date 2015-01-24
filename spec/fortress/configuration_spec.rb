require 'spec_helper'

describe Fortress::Configuration do
  describe 'default configuration' do
    it 'should keep a blank configuration' do
      expect(Fortress.configuration).to be_nil
    end
  end
  describe 'externals option' do
    context 'passing nil' do
      before { Fortress.configure { |config| config.externals = nil } }
      it 'should keep a blank configuration' do
        expect(Fortress.configuration.options).to be_nil
      end
    end
    context 'passing a String' do
      before do
        Fortress.configure { |config| config.externals = 'IronMaiden' }
      end
      it 'should add the externals key as an Array with the given string' do
        options = { externals: ['IronMaiden'] }
        expect(Fortress.configuration.options).to eql(options)
      end
    end
    context 'passing an Array of String' do
      before do
        Fortress.configure do |config|
          config.externals = %w(Rocksmith IronMaiden Pantera)
        end
      end
      it 'should add the externals key as an Array with the given string' do
        options = { externals: %w(Rocksmith IronMaiden Pantera) }
        expect(Fortress.configuration.options).to eql(options)
      end
    end
  end
end
