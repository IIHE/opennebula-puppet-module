#!/usr/bin/env rspec

require 'spec_helper'

res_type_name = :onehost
res_type = Puppet::Type.type(res_type_name)

describe res_type do
  before :each do
    @host = res_type.new(name: 'test')
  end

  it 'has :name be its namevar' do
    expect(res_type.key_attributes).to eq([:name])
  end

  it 'has property :im_mad' do
    @host[:im_mad] = 'kvm'
    expect(@host[:im_mad]).to eq(:kvm)
  end

  it 'has property :im_mad with kvm_pull' do
    @host[:im_mad] = 'kvm_pull'
    expect(@host[:im_mad]).to eq(:kvm_pull)
  end

  it 'has property :vm_mad' do
    @host[:vm_mad] = 'kvm'
    expect(@host[:vm_mad]).to eq(:kvm)
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
