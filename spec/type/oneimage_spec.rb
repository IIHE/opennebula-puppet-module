#!/usr/bin/env rspec

require 'spec_helper'

res_type_name = :oneimage
res_type = Puppet::Type.type(res_type_name)

describe res_type do
  before :each do
    @image = res_type.new(name: 'test')
  end

  it 'has :name be its namevar' do
    expect(res_type.key_attributes).to eq([:name])
  end

  it 'has property :datastore' do
    @image[:datastore] = 'ds1'
    expect(@image[:datastore]).to eq('ds1')
  end

  it 'has property :description' do
    @image[:description] = 'foo'
    expect(@image[:description]).to eq('foo')
  end

  it 'has property :type' do
    @image[:type] = 'os'
    expect(@image[:type]).to eq(:OS)
  end

  it 'has property :persistent' do
    @image[:persistent] = :true
    expect(@image[:persistent]).to eq(:true)
  end

  it 'has property :dev_prefix' do
    @image[:dev_prefix] = 'hd'
    expect(@image[:dev_prefix]).to eq('hd')
  end

  it 'has propery :target' do
    @image[:target] = 'hda'
    expect(@image[:target]).to eq('hda')
  end

  it 'has property :path' do
    @image[:path] = '/foo'
    expect(@image[:path]).to eq('/foo')
  end

  it 'has property :driver' do
    @image[:driver] = 'raw'
    expect(@image[:driver]).to eq('raw')
  end

  it 'has property :disk_type' do
    @image[:disk_type] = 'block'
    expect(@image[:disk_type]).to eq('block')
  end

  it 'has property :source' do
    @image[:source] = 'foo'
    expect(@image[:source]).to eq('foo')
  end

  it 'has property :size' do
    @image[:size] = '4096'
    expect(@image[:size]).to eq('4096')
  end

  it 'has property :fstype' do
    @image[:fstype] = 'ext2'
    expect(@image[:fstype]).to eq('ext2')
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
