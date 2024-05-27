#!/usr/bin/env rspec

require 'spec_helper'

provider_class = Puppet::Type.type(:onesecgroup).provider(:onesecgroup)
describe provider_class do
  let(:resource) {
    Puppet::Type::onesecgroup.new({ name: 'new_secgroup', })
  }

  let(:provider) {
    @provider = provider_class.new(@resource)
  }

  it 'exists' do
    @provider
  end

  context 'when checking if resource exists' do
    it 'returns true if resource exists' do
      skip('needs test to verify existance')
    end
    it 'returns false if reosurce does not exists' do
      skip('needs test to verify absence')
    end
  end
  context 'when creating' do
    it 'creates tempfile with proper values' do
      skip('needs tests to verify creation')
    end
  end
  context 'when deleting' do
    it 'runs onesecgroup delete <name>' do
      skip('needs test to verify removal')
    end
  end
  context 'when updating' do
    skip('update needs all tests')
  end

end
