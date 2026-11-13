#!/usr/bin/env rspec

require 'spec_helper'

provider_class = Puppet::Type.type(:onehost).provider(:cli_5_0)

describe provider_class do
  let(:resource) do
    Puppet::Type::Onehost.new(name: 'new_host')
  end

  subject(:provider) { described_class.new(resource) }

  it 'exists' do
    expect(described_class).to be_a(Class)
  end

  it 'can be instantiated' do
    expect(provider).to be_a(described_class)
  end
end
