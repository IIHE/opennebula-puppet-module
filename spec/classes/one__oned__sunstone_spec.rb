require 'spec_helper'

hiera_config = 'spec/fixtures/hiera/hiera.yaml'

describe 'one::oned::sunstone', type: :class do
  on_supported_os.each do |os, os_facts|
    context "On #{os}" do
      let(:facts) { os_facts }
      let (:hiera_config) { hiera_config }
      let (:pre_condition) { 'include one' }
      context 'general' do
        let (:params) { { ldap: false } }
        it { is_expected.to contain_class('one::prerequisites') }
        it { is_expected.to contain_class('one::oned::sunstone') }
        it { is_expected.to contain_class('one::oned::sunstone::install') }
        it { is_expected.to contain_class('one::oned::sunstone::config') }
        it { is_expected.to contain_class('one::oned::sunstone::service') }
        it { is_expected.not_to contain_class('one::oned::sunstone::ldap') }
      end
      context 'with ldap enabled' do
        let (:params) { { ldap: true } }
        it { is_expected.to contain_class('one::oned::sunstone::ldap') }
      end
    end
  end
end
