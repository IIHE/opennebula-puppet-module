#!/usr/bin/env rspec

require 'spec_helper'

res_type_name = :onedatastore
res_type = Puppet::Type.type(res_type_name)

describe res_type do
  before :each do
    @datastore = res_type.new(name: 'test')
  end

  it 'has :name be its namevar' do
    expect(res_type.key_attributes).to eq([:name])
  end

  properties = [:tm_mad, :type, :safe_dirs, :ds_mad, :disk_type, :driver, :bridge_list,
                :ceph_host, :ceph_user, :ceph_secret, :pool_name, :staging_dir, :base_path,
                :cluster]

  properties.each do |property|
    it "has a #{property} property" do
      expect(described_class.attrclass(property).ancestors).to include(Puppet::Property)
    end

    it "has documentation for its #{property} property" do
      expect(described_class.attrclass(property).doc).to be_a(String)
    end
  end

  it 'has property :type' do
    @datastore[:type] = 'IMAGE_DS'
    expect(@datastore[:type]).to eq(:IMAGE_DS)
  end

  it 'has property :ds_mad' do
    @datastore[:ds_mad] = 'baz'
    expect(@datastore[:ds_mad]).to eq('baz')
  end

  it 'has property :tm_MAD' do
    @datastore[:tm_mad] = 'foobar'
    expect(@datastore[:tm_mad]).to eq('foobar')
  end

  it 'has property :disk_type' do
    @datastore[:disk_type] = 'file'
    expect(@datastore[:disk_type]).to eq('file')
  end

  it 'has property :driver' do
    @datastore[:driver] = 'qcow2'
    expect(@datastore[:driver]).to eq('qcow2')
  end

  it 'has property :ceph_host' do
    @datastore[:ceph_host] = 'cephhost'
    expect(@datastore[:ceph_host]).to eq('cephhost')
  end

  it 'has property :ceph_user' do
    @datastore[:ceph_user] = 'cephuser'
    expect(@datastore[:ceph_user]).to eq('cephuser')
  end

  it 'has property :ceph_secret' do
    @datastore[:ceph_secret] = 'cephsecret'
    expect(@datastore[:ceph_secret]).to eq('cephsecret')
  end

  it 'has property :ceph_conf' do
    @datastore[:ceph_conf] = '/etc/ceph/somecluster.conf'
    expect(@datastore[:ceph_conf]).to eq('/etc/ceph/somecluster.conf')
  end

  it 'has property :ceph_key' do
    @datastore[:ceph_key] = '/opt/custom/somecluster.client.admin.keyring'
    expect(@datastore[:ceph_key]).to eq('/opt/custom/somecluster.client.admin.keyring')
  end

  it 'has property :ec_pool_name' do
    @datastore[:ec_pool_name] = 'my_ec_pool'
    expect(@datastore[:ec_pool_name]).to eq('my_ec_pool')
  end

  it 'has property :poolname' do
    @datastore[:pool_name] = 'poolname'
    expect(@datastore[:pool_name]).to eq('poolname')
  end

  it 'has property :bridgelist' do
    @datastore[:bridge_list] = 'host1 host2 host3'
    expect(@datastore[:bridge_list]).to eq('host1 host2 host3')
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
