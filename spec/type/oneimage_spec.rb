#!/usr/bin/env rspec

require 'spec_helper'

res_type_name = :oneimage
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
    @image = res_type.new(name: 'test')
  end

  it 'has :name be its namevar' do
    res_type.key_attributes.should == [:name]
  end

  it 'has property :datastore' do
    @image[:datastore] = 'ds1'
    @image[:datastore].should == 'ds1'
  end

  it 'has property :description' do
    @image[:description] = 'foo'
    @image[:description].should == 'foo'
  end

  it 'has property :type' do
    @image[:type] = 'os'
    @image[:type].should == :OS
  end

  it 'has property :persistent' do
    @image[:persistent] = :true
    @image[:persistent].should == :true
  end

  it 'has property :dev_prefix' do
    @image[:dev_prefix] = 'hd'
    @image[:dev_prefix].should == 'hd'
  end

  it 'has propery :target' do
    @image[:target] = 'hda'
    @image[:target].should == 'hda'
  end

  it 'has property :path' do
    @image[:path] = '/foo'
    @image[:path].should == '/foo'
  end

  it 'has property :driver' do
    @image[:driver] = 'raw'
    @image[:driver].should == 'raw'
  end

  it 'has property :disk_type' do
    @image[:disk_type] = 'block'
    @image[:disk_type].should == 'block'
  end

  it 'has property :soruce' do
    @image[:source] = 'foo'
    @image[:source].should == 'foo'
  end

  it 'has property :size' do
    @image[:size] = '4096'
    @image[:size].should == '4096'
  end

  it 'has property :fstype' do
    @image[:fstype] = 'ext2'
    @image[:fstype].should == 'ext2'
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
