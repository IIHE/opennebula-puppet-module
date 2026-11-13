require 'spec_helper'

describe 'one::config', type: :class do
  on_supported_os.each do |os, os_facts|
    context "On #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          ssh_pub_key: 'ssh pub key',
          ssh_priv_key: 'ssh private key',
        }
      end

      it { is_expected.to contain_class('one::config') }
      it { is_expected.to contain_file('/var/lib/one').with_ensure('directory').with_owner('oneadmin').with_group('oneadmin') }
      it { is_expected.to contain_file('/var/lib/one/.ssh/id_rsa').with_content('ssh private key') }
      it { is_expected.to contain_file('/var/lib/one/.ssh/id_rsa.pub').with_content('ssh pub key') }
      it { is_expected.to contain_file('/var/lib/one/.ssh/authorized_keys').with_content('ssh pub key') }
    end
  end
end
