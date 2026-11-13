require 'spec_helper'

describe 'one::oned::sunstone::config', type: :class do
  on_supported_os.each do |os, os_facts|
    context "On #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { "include one\nservice { ['opennebula-fireedge', 'opennebula-sunstone']: }" }

      context 'general' do
        it { is_expected.to contain_class('one::oned::sunstone::config') }
        it { is_expected.to contain_file('/etc/one/sunstone-server.conf').with_ensure('file') }
        it { is_expected.to contain_file('/etc/one/sunstone-views.yaml').with_ensure('file') }
        it { is_expected.to contain_file('/etc/one/sunstone-views/mixed/admin.yaml').with_ensure('file') }
        it { is_expected.to contain_file('/etc/one/sunstone-views/mixed/cloud.yaml').with_ensure('file') }
        it { is_expected.to contain_file('/etc/one/sunstone-views/mixed/user.yaml').with_ensure('file') }
      end

      context 'with sunstone listen ip set' do
        let(:params) { { listen_ip: '1.2.3.4' } }

        it { is_expected.to contain_file('/etc/one/sunstone-server.conf').with_content(/:host: 1.2.3.4/m) }
      end

      context 'with support enabled' do
        let(:params) { { enable_support: 'yes' } }

        expected_routes = ":routes:
    - oneflow
    - vcenter
    - support"

        it { is_expected.to contain_file('/etc/one/sunstone-server.conf').with_content(/#{expected_routes}/m) }
      end

      context 'with support disabled' do
        let(:params) { { enable_support: 'no' } }

        unexpected_routes = "
    - vcenter
    - support"

        it { is_expected.not_to contain_file('/etc/one/sunstone-server.conf').with_content(/#{unexpected_routes}/m) }
      end

      context 'with ONE 7.4' do
        let(:pre_condition) { "class { 'one': one_version => '7.4' }\nservice { ['opennebula-fireedge', 'opennebula-sunstone']: }" }

        it { is_expected.to contain_file('/etc/one/fireedge-server.conf').with_ensure('file') }
      end
    end
  end
end
