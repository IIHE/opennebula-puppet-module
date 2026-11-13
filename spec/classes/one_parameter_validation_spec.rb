require 'spec_helper'

describe 'one', type: :class do
  on_supported_os.each do |os, os_facts|
    context "On #{os}" do
      let(:facts) { os_facts }

      %w<oned_xmlrpc_maxconn oned_xmlrpc_maxconn_backlog oned_xmlrpc_keepalive_timeout oned_xmlrpc_keepalive_max_conn oned_xmlrpc_timeout>.each do |param|
        context "given a non-integer value for #{param}" do
          let(:params) { { param => 'foobar' } }

          it { is_expected.to compile.and_raise_error(/expects an Integer value/) }
        end

        context "given an integer value for #{param}" do
          let(:params) { { param => 42 } }

          it { is_expected.to compile }
        end
      end

      %w<oned_inherit_datastore_attrs hook_scripts_pkgs>.each do |param|
        context "given a non-array value for #{param}" do
          let(:params) { { param => 'string' } }

          it { is_expected.to compile.and_raise_error(/expects an Array value/) }
        end

        context "given an array value for #{param}" do
          let(:params) { { param => ['foo', 'bar'] } }

          it { is_expected.to compile }
        end
      end

      context 'validating hook scripts' do
        context 'given a non-hash value for hook_scripts' do
          let(:params) { { 'hook_scripts' => 'string' } }

          it { is_expected.to compile.and_raise_error(/expects a Hash value/) }
        end

        context 'given a non-hash value for a VM hook script' do
          let(:params) { { 'hook_scripts' => { 'VM' => 'string' } } }

          it { is_expected.to compile.and_raise_error(/is not a Hash/) }
        end

        context 'given a non-hash value for a HOST hook script' do
          let(:params) { { 'hook_scripts' => { 'HOST' => 'string' } } }

          it { is_expected.to compile.and_raise_error(/is not a Hash/) }
        end

        context 'given the expected format for hook_scripts' do
          let(:params) do
            {
              'hook_scripts' => {
                'HOST' => { 'foo' => 'bar' },
                'VM'   => { 'foo' => 'bar' },
              },
            }
          end

          it { is_expected.to compile }
        end
      end

      context 'given a non-absolute path for oneadmin_sudoers_file' do
        let(:params) { { 'oneadmin_sudoers_file' => 'relative/path/to/oneadmin_sudoers_file' } }

        it { is_expected.to compile.and_raise_error(/expects a Stdlib::Absolutepath/) }
      end

      context 'with valid ssh keys' do
        let(:params) do
          {
            'ssh_pub_key' => 'ssh pub key',
            'ssh_priv_key_param' => 'ssh private key',
          }
        end

        it { is_expected.to compile }
      end

      context 'with an unsupported OpenNebula version' do
        let(:params) { { 'one_version' => '5.8', 'sunstone_fireedge' => false } }

        it { is_expected.to compile.and_raise_error(/One_version 5\.8 not supported/) }
      end

      context 'with fireedge and an OpenNebula version older than 6' do
        let(:params) { { 'one_version' => '5.12', 'sunstone_fireedge' => true } }

        it { is_expected.to compile.and_raise_error(/Fireedge is only available as of OpenNebula 6/) }
      end
    end
  end
end
