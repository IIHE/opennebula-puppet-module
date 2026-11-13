#!/usr/bin/env rspec

require 'spec_helper'

res_type_name = :onevm
res_type = Puppet::Type.type(res_type_name)

describe res_type do
  before :each do
    @vm = res_type.new(name: 'test')
  end

  it 'has :name be its namevar' do
    expect(res_type.key_attributes).to eq([:name])
  end

  it 'has property :template' do
    @vm[:template] = 'abc'
    expect(@vm[:template]).to eq('abc')
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
