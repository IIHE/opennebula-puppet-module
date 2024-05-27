#!/usr/bin/env rspec

require 'spec_helper'

provider_class = Puppet::Type.type(:onetemplate).provider(:onetemplate)
describe provider_class do
  let(:resource) {
    Puppet::Type::Onetemplate.new({ name: 'new_cluster', })
  }

  let(:provider) {
    @provider = provider_class.new(@resource)
  }

  it 'exists' do
    @provider
  end
end
