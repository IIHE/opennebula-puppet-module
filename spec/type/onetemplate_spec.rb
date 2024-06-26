#!/usr/bin/env rspec

require 'spec_helper'

res_type_name = :onetemplate
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
  #  let(:resource) {
  #    res_type.new({:name => 'test'})
  #  }
  before :each do
    @template = res_type.new(name: 'test')
  end

  it 'has :name be its namevar' do
    res_type.key_attributes.should == [:name]
  end

  it 'has property :memory' do
    @template[:memory] = '4096'
    @template[:memory].should == '4096'
  end

  it 'has property :cpu' do
    @template[:cpu] = '0.5'
    @template[:cpu].should == '0.5'
  end

  it 'has property :vcpu' do
    @template[:vcpu] = '8'
    @template[:vcpu].should == '8'
  end

  it 'has property :disks' do
    @template[:disks] = ['base', 'storage']
    @template[:disks].should == [{ 'image' => 'base' }, { 'image' => 'storage' }]
  end

  it 'has property :nics' do
    @template[:nics] = ['core', 'backup']
    @template[:nics].should == [{ 'network' => 'core' }, { 'network' => 'backup' }]
  end

  it 'has property :context' do
    @template[:context] = 'foo'
    @template[:context].should == 'foo'
  end

  parameter_tests = {
    name: {
      valid: ['test', 'foo'],
      default: 'test',
      invalid: ['0./fouzb&$', '&fr5'],
    },
  }
  it_should_behave_like 'a puppet type', parameter_tests, res_type_name
end
