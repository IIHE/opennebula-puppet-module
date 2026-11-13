#!/usr/bin/env rspec

require 'spec_helper'

provider_class = Puppet::Type.type(:oneimage).provider(:cli_6_0)

describe provider_class do
  let(:resource) do
    Puppet::Type::Oneimage.new(name: 'new_image')
  end

  subject(:provider) { described_class.new(resource) }

  it 'exists' do
    expect(described_class).to be_a(Class)
  end

  it 'can be instantiated' do
    expect(provider).to be_a(described_class)
  end
end
