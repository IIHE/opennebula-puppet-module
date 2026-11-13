#!/usr/bin/env rspec

require 'spec_helper'

res_type_name = :onecluster
res_type = Puppet::Type.type(res_type_name)

describe res_type do
  before :each do
    @cluster = res_type.new(name: 'test', hosts: ['node1', 'node2'])
  end

  it 'has :name be its namevar' do
    expect(res_type.key_attributes).to eq([:name])
  end

  properties = [:hosts, :vnets, :datastores]

  properties.each do |property|
    it "has a #{property} property" do
      expect(described_class.attrclass(property).ancestors).to include(Puppet::Property)
    end

    it "has documentation for its #{property} property" do
      expect(described_class.attrclass(property).doc).to be_a(String)
    end
  end

  it 'has property :hosts' do
    expect(@cluster[:hosts]).to eq(['node1', 'node2'])
  end

  it 'has property :vnets' do
    @cluster[:vnets] = ['vnet1', 'vnet2']
    expect(@cluster[:vnets]).to eq(['vnet1', 'vnet2'])
  end

  it 'has property :datastores' do
    @cluster[:datastores] = ['ds1', 'ds2']
    expect(@cluster[:datastores]).to eq(['ds1', 'ds2'])
  end

  parameter_tests = {
    name: {
      valid: ['test', 'foo'],
      default: 'test',
      invalid: ['0./fouzb&$', '&fr5'],
    },
  }
  it_should_behave_like 'a puppet type', parameter_tests, res_type_name

  it 'fails when passing host without being declared as onehost' do
    skip('needs tests to verify onehost resource declaration')
  end
  it 'fails when passing vnet without being declared as onevnet' do
    skip('needs tests to verify onevnet resource declaration')
  end
  it 'fails when passing datastore without being declared as onedatastore' do
    skip('needs tests to verify onedatastore resource declaration')
  end
  it 'autorequires host' do
    skip('needs host autorequire to be built in')
  end
  it 'autorequires vnet' do
    skip('needs vnet autorequire to be built in ')
  end
  it 'autorequires datastore' do
    skip('needs datastore autorequire to be built in')
  end
end
