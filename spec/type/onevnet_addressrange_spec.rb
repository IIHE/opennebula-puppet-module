#!/usr/bin/env rspec

require 'spec_helper'

res_type_name = :onevnet_addressrange
res_type = Puppet::Type.type(res_type_name)

describe res_type do
  before :each do
    @vnet4 = res_type.new(name: 'test', onevnet_name: 'testnet')
    @vnet6 = res_type.new(name: 'test', onevnet_name: 'testnet')
  end

  it 'has :name be its namevar' do
    expect(res_type.key_attributes).to eq([:name])
  end

  properties = [:onevnet_name, :ar_id, :protocol, :ip_start, :ip_size, :mac, :globalprefix, :ulaprefix]

  properties.each do |property|
    it "has a #{property} property" do
      expect(described_class.attrclass(property).ancestors).to include(Puppet::Property)
    end

    it "has documentation for its #{property} property" do
      expect(described_class.attrclass(property).doc).to be_a(String)
    end
  end

  it 'has property :onevnet_name' do
    @vnet4[:onevnet_name] = 'testnet'
    expect(@vnet4[:onevnet_name]).to eq('testnet')
  end

  it 'has property :protocol' do
    @vnet4[:protocol] = 'ip4'
    expect(@vnet4[:protocol]).to eq(:ip4)
  end

  it 'has property :ip_start' do
    @vnet6[:ip_start] = '10.0.2.3'
    expect(@vnet6[:ip_start]).to eq('10.0.2.3')
  end

  it 'has property :globalprefix' do
    @vnet6[:globalprefix] = '64'
    expect(@vnet6[:globalprefix]).to eq('64')
  end

  it 'has property :mac' do
    @vnet6[:mac] = 'aa:bb:cc:dd:ee:ff'
    expect(@vnet6[:mac]).to eq('aa:bb:cc:dd:ee:ff')
  end

  it 'has property :ip_size' do
    @vnet6[:ip_size] = '33'
    expect(@vnet6[:ip_size]).to eq('33')
  end

  it 'fails when passing wrong paramter to mac' do
    skip('needs parameter validation')
  end

  it 'fails when passing ipv4 and not providing ip' do
    skip('needs parameter validation')
  end

  it 'fails when passing ipv4 and not providing size' do
    skip('needs parameter validation')
  end
end
