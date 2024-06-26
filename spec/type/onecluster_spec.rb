#!/usr/bin/env rspec

require 'spec_helper'

res_type_name = :onecluster
res_type = Puppet::Type.type(res_type_name)

describe res_type do
  let(:provider) {
    prov = stub 'provider'
    prov.stubs(:name).returns(res_type_name)
    prov
  }
  let(:res_type) {
    val = res_type
    val.stubs(:defaultprovider).returns provider
    val
  }
  before :each do
    @cluster = res_type.new(name: 'test', hosts: ['node1', 'node2'])
  end

  it 'has :name be its namevar' do
    res_type.key_attributes.should == [:name]
  end

  properties = [:hosts, :vnets, :datastores]

  properties.each do |property|
    it "has a #{property} property" do
      described_class.attrclass(property).ancestors.should be_include(Puppet::Property)
    end

    it "has documentation for its #{property} property" do
      described_class.attrclass(property).doc.should be_instance_of(String)
    end
  end

  it 'has property :hosts' do
    @cluster[:hosts].should == ['node1', 'node2']
  end

  it 'has property :vnets' do
    @cluster[:vnets] = ['vnet1', 'vnet2']
    @cluster[:vnets].should == ['vnet1', 'vnet2']
  end

  it 'has property :datastores' do
    @cluster[:datastores] = ['ds1', 'ds2']
    @cluster[:datastores].should == ['ds1', 'ds2']
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
