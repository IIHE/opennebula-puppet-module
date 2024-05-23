require 'spec_helper'

hiera_config = 'spec/fixtures/hiera/hiera.yaml'

describe 'one::oned::sunstone::ldap', type: :class do
  on_supported_os.each do |os, os_facts|
    context "On #{os}" do
      let(:facts) { os_facts }
      let (:hiera_config) { hiera_config }
      let (:params) { { oned_sunstone_ldap_pkg: 'bogus-ldap-package' } }
      context 'general' do
        it { is_expected.to contain_class('one::oned::sunstone::ldap') }
        it { is_expected.to contain_package('bogus-ldap-package').with_ensure('latest') }
        it { is_expected.to contain_file('/var/lib/one/remotes/auth/default') \
          .with_ensure('link') \
          .with_target('/var/lib/one/remotes/auth/ldap')
        }
        ### move all variables in ldap_auth.conf to parameters of this class?
        it { is_expected.to contain_file('/etc/one/auth/ldap_auth.conf') \
          .with_ensure('file') \
          .with_mode('0640') \
          .with_notify('Service[opennebula]')
        }
      end
    end
  end
end
