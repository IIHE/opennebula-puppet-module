#!/usr/bin/env rspec

require 'spec_helper'

res_type_name = :onesecgroup
res_type = Puppet::Type.type(res_type_name)

describe res_type do
  before :each do
    @secgroup = res_type.new(name: 'test')
  end

  it 'has :name be its namevar' do
    expect(res_type.key_attributes).to eq([:name])
  end

  properties = [:description, :rules]

  properties.each do |property|
    it "has a #{property} property" do
      expect(described_class.attrclass(property).ancestors).to include(Puppet::Property)
    end

    it "has documentation for its #{property} property" do
      expect(described_class.attrclass(property).doc).to be_a(String)
    end
  end

  it 'has property :description' do
    @secgroup[:description] = 'This is a description.'
    expect(@secgroup[:description]).to eq('This is a description.')
  end

  it 'has property :rules' do
    @secgroup[:rules] = [{ 'protocol' => 'ALL', 'rule_type' => 'OUTBOUND' }, { 'protocol' => 'ALL', 'rule_type' => 'INBOUND' }]
    expect(@secgroup[:rules]).to eq([{ 'protocol' => 'ALL', 'rule_type' => 'OUTBOUND' }, { 'protocol' => 'ALL', 'rule_type' => 'INBOUND' }])
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
