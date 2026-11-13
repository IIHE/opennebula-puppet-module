#!/usr/bin/env rspec

require 'spec_helper'

res_type_name = :onevnet
res_type = Puppet::Type.type(res_type_name)

describe res_type do
  before :each do
    @vnet = res_type.new(name: 'test')
  end

  it 'has :name be its namevar' do
    expect(res_type.key_attributes).to eq([:name])
  end

  properties = [:dnsservers, :gateway, :model, :bridge, :vlanid, :context, :phydev, :netmask, :network_address]

  properties.each do |property|
    it "has a #{property} property" do
      expect(described_class.attrclass(property).ancestors).to include(Puppet::Property)
    end

    it "has documentation for its #{property} property" do
      expect(described_class.attrclass(property).doc).to be_a(String)
    end
  end

  it 'has property :dnsservers' do
    @vnet[:dnsservers] = ['8.8.8.8', '4.4.4.4']
    expect(@vnet[:dnsservers]).to eq(['8.8.8.8', '4.4.4.4'])
  end

  it 'has property :gateway' do
    @vnet[:gateway] = '10.0.2.1'
    expect(@vnet[:gateway]).to eq('10.0.2.1')
  end

  it 'has property :model' do
    @vnet[:model] = 'vlan'
    expect(@vnet[:model]).to eq(:vlan)
  end

  it 'has property :bridge' do
    @vnet[:bridge] = 'br0'
    expect(@vnet[:bridge]).to eq('br0')
  end

  it 'has property :context' do
    @vnet[:context] = 'foo'
    expect(@vnet[:context]).to eq('foo')
  end

  it 'has property :phydev' do
    @vnet[:phydev] = 'eth0'
    expect(@vnet[:phydev]).to eq('eth0')
  end

  it 'has property :netmask' do
    @vnet[:netmask] = '255.255.0.0'
    expect(@vnet[:netmask]).to eq('255.255.0.0')
  end

  it 'has property network_address' do
    @vnet[:network_address] = '10.0.2.0'
    expect(@vnet[:network_address]).to eq('10.0.2.0')
  end

  parameter_tests = {
    name: {
      valid: ['test', 'foo'],
      default: 'test',
      invalid: ['0./fouzb&$', '&fr5'],
    },
  }
  it_should_behave_like 'a puppet type', parameter_tests, res_type_name

  it 'fails when passing wrong argument to model' do
    expect {
      @vnet[:model] = 'foo'
    }.to raise_error(Puppet::Error)
  end

  it 'fails when passing ipv4 and not providing DNS server' do
    skip('needs parameter validation')
  end
end
