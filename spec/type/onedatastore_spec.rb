#!/usr/bin/env rspec

require 'spec_helper'

res_type_name = :onedatastore
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
    @datastore = res_type.new(name: 'test')
  end
  it 'has :name be its namevar' do
    res_type.key_attributes.should == [:name]
  end

  properties = [:tm_mad, :type, :safe_dirs, :ds_mad, :disk_type, :driver, :bridge_list,
                :ceph_host, :ceph_user, :ceph_secret, :pool_name, :staging_dir, :base_path,
                :cluster]

  properties.each do |property|
    it "has a #{property} property" do
      described_class.attrclass(property).ancestors.should be_include(Puppet::Property)
    end

    it "has documentation for its #{property} property" do
      described_class.attrclass(property).doc.should be_instance_of(String)
    end
  end

  it 'has property :type' do
    @datastore[:type] = 'IMAGE_DS'
    @datastore[:type].should == :IMAGE_DS
  end

  it 'has property :ds_mad' do
    @datastore[:ds_mad] = 'baz'
    @datastore[:ds_mad].should == 'baz'
  end

  it 'has property :tm_MAD' do
    @datastore[:tm_mad] = 'foobar'
    @datastore[:tm_mad].should == 'foobar'
  end

  it 'has property :disk_type' do
    @datastore[:disk_type] = 'file'
    @datastore[:disk_type].should == 'file'
  end

  it 'has property :driver' do
    @datastore[:driver] = 'qcow2'
    @datastore[:driver].should == 'qcow2'
  end

  it 'has property :ceph_host' do
    @datastore[:ceph_host] = 'cephhost'
    @datastore[:ceph_host].should == 'cephhost'
  end

  it 'has property :ceph_user' do
    @datastore[:ceph_user] = 'cephuser'
    @datastore[:ceph_user].should == 'cephuser'
  end

  it 'has property :ceph_secret' do
    @datastore[:ceph_secret] = 'cephsecret'
    @datastore[:ceph_secret].should == 'cephsecret'
  end

  it 'has property :ceph_conf' do
    @datastore[:ceph_conf] = '/etc/ceph/somecluster.conf'
    @datastore[:ceph_conf].should == '/etc/ceph/somecluster.conf'
  end

  it 'has property :ceph_key' do
    @datastore[:ceph_key] = '/opt/custom/somecluster.client.admin.keyring'
    @datastore[:ceph_key].should == '/opt/custom/somecluster.client.admin.keyring'
  end

  it 'has property :ec_pool_name' do
    @datastore[:ec_pool_name] = 'my_ec_pool'
    @datastore[:ec_pool_name].should == 'my_ec_pool'
  end

  it 'has property :poolname' do
    @datastore[:pool_name] = 'poolname'
    @datastore[:pool_name].should == 'poolname'
  end

  it 'has property :bridgelist' do
    @datastore[:bridge_list] = 'host1 host2 host3'
    @datastore[:bridge_list].should == 'host1 host2 host3'
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
