#!/usr/bin/env rspec

require 'spec_helper'

res_type_name = :onetemplate
res_type = Puppet::Type.type(res_type_name)

describe res_type do
  before :each do
    @template = res_type.new(name: 'test')
  end

  it 'has :name be its namevar' do
    expect(res_type.key_attributes).to eq([:name])
  end

  it 'has property :memory' do
    @template[:memory] = '4096'
    expect(@template[:memory]).to eq('4096')
  end

  it 'has property :cpu' do
    @template[:cpu] = '0.5'
    expect(@template[:cpu]).to eq('0.5')
  end

  it 'has property :vcpu' do
    @template[:vcpu] = '8'
    expect(@template[:vcpu]).to eq('8')
  end

  it 'has property :disks' do
    @template[:disks] = ['base', 'storage']
    expect(@template[:disks]).to eq([{ 'image' => 'base' }, { 'image' => 'storage' }])
  end

  it 'has property :nics' do
    @template[:nics] = ['core', 'backup']
    expect(@template[:nics]).to eq([{ 'network' => 'core' }, { 'network' => 'backup' }])
  end

  it 'has property :context' do
    @template[:context] = 'foo'
    expect(@template[:context]).to eq('foo')
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
