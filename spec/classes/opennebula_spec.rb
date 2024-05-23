require 'spec_helper'

hiera_config = 'spec/fixtures/hiera/hiera.yaml'

describe 'one', type: :class do
  let(:hiera_config) { hiera_config }
  on_supported_os.each do |os, os_facts|
    context 'with default params as implicit hiera lookup' do
      let (:facts) { os_facts }
      it { is_expected.to contain_class('one') }
      it { is_expected.to_not contain_file('/etc/one/oned.conf').with_content(/^DB = \[ backend = \"sqlite\"/) }
      it { is_expected.to_not contain_class('one::oned') }
    end
    context "On #{os}" do
      let(:facts) { os_facts }
      context 'with hiera config' do
        let(:params) { { oned: true } }
        hiera = Hiera.new(config: hiera_config)
        configdir = '/etc/one'
        onehome = '/var/lib/one'
        oned_config = "#{configdir}/oned.conf"
        context 'with one module' do
          it { is_expected.to contain_class('one') }
          it { is_expected.to contain_class('one::prerequisites') }
          it { is_expected.to contain_class('one::install') }
          it { is_expected.to contain_class('one::config') }
          it { is_expected.to contain_class('one::service') }
          it { is_expected.to contain_package('dbus') }
          it { is_expected.to contain_file(onehome).with_ensure('directory').with_owner('oneadmin') }
          it { is_expected.to contain_file('/usr/share/one').with_ensure('directory') }
          it { is_expected.to contain_file("#{onehome}/.ssh").with_ensure('directory') }
          it { is_expected.to contain_file("#{onehome}/.ssh/config").with_ensure('file') }
          if (os_facts[:osfamily] == 'Debian') or (os_facts[:osfamily] == 'RedHat' and os_facts[:operatingsystemmajrelease].to_i < 7)
            it { is_expected.to contain_file('/sbin/brctl').with_ensure('link') }
          end
          it { is_expected.to contain_file('/etc/libvirt/qemu.conf').with_ensure('file') }
          it { is_expected.to contain_file('/etc/sudoers.d/20_imaginator').with_ensure('file') }
          it { is_expected.to contain_file('/etc/udev/rules.d/80-kvm.rules').with_ensure('file') }
          if os_facts[:osfamily] == 'Redhat'
            it { is_expected.to contain_service('messagebus').with_ensure('running') }
          elsif os_facts[:osfamily] == 'Debian'
            it { is_expected.to contain_service('dbus').with_ensure('running') }
          end
          context 'as compute_node' do
            let(:params) { {
              oned: false,
              node: true,
            } }
            networkconfig = hiera.lookup('one::node::kickstart::network', nil, nil)
            sshpubkey = hiera.lookup('one::head::ssh_pub_key', nil, nil)
            it { is_expected.to contain_class('one::compute_node') }
            it { is_expected.to contain_class('one::compute_node::install') }
            it { is_expected.to contain_class('one::compute_node::config') }
            it { is_expected.to contain_class('one::compute_node::service') }
            it { is_expected.to contain_one__compute_node__add_kickstart('foo') }
            it { is_expected.to contain_one__compute_node__add_kickstart('rnr') }
            it { is_expected.to contain_one__compute_node__add_preseed('does') }
            if os_facts[:osfamily] == 'RedHat'
              it { is_expected.to contain_package('opennebula-node-kvm') }
            elsif os_facts[:osfamily] == 'Debian'
              it { is_expected.to contain_package('opennebula-node') }
            end

            if os_facts[:osfamily] == 'RedHat' and os_facts[:operatingsystemmajrelease].to_i < 7
              it { is_expected.to contain_package('python-virtinst') }
            elsif os_facts[:osfamily] == 'Debian'
              it { is_expected.to contain_package('virtinst') }
            end
            it { is_expected.to contain_group('oneadmin') }
            it { is_expected.to contain_user('oneadmin') }
            it { is_expected.to contain_file('/etc/libvirt/libvirtd.conf').with_ensure('file') }
            if os_facts[:osfamily] == 'RedHat'
              it { is_expected.to contain_file('/etc/sysconfig/libvirtd').with_ensure('file') }
            elsif os_facts[:osfamily] == 'Debian'
              it { is_expected.to contain_file('/etc/default/libvirt-bin').with_ensure('file') }
            end
            it { is_expected.to contain_file("#{onehome}/.ssh/authorized_keys").with_ensure('file').with_content(/#{sshpubkey}/m) }
            it { is_expected.to contain_file('/etc/sudoers.d/10_oneadmin').with_ensure('file') }

            if os_facts[:osfamily] == 'RedHat'
              it { is_expected.to contain_service('libvirtd').with_ensure('running') }
            elsif os_facts[:osfamily] == 'Debian'
              it { is_expected.to contain_service('libvirt-bin').with_ensure('running') }
            end
            if os_facts[:osfamily] == 'RedHat'
              it { is_expected.to contain_service('ksm').with_ensure('running') }
              it { is_expected.to contain_service('ksmtuned').with_ensure('stopped') }
            end
            context 'with imaginator' do
              it { is_expected.to contain_file("#{onehome}/.virtinst").with_ensure('directory') }
              it { is_expected.to contain_file("#{onehome}/.libvirt").with_ensure('directory') }
              it { is_expected.to contain_file('/var/lib/libvirt/boot').with_owner('oneadmin').with_group('oneadmin').with_mode('0771') }
              it { is_expected.to contain_file("#{onehome}/bin").with_ensure('directory') }
              it { is_expected.to contain_file("#{onehome}/bin/imaginator").with_source('puppet:///modules/one/imaginator') }
              it { is_expected.to contain_file("#{onehome}/etc").with_ensure('directory') }
              it { is_expected.to contain_file("#{onehome}/etc/kickstart.d").with_ensure('directory') }
              it { is_expected.to contain_file("#{onehome}/etc/preseed.d").with_ensure('directory') }
              context 'with kickstart for RedHat' do
                it { is_expected.to contain_file("#{onehome}/etc/kickstart.d/foo.ks").with_content(/context/m) }
                it { is_expected.to contain_file("#{onehome}/etc/kickstart.d/foo.ks").with_content(/device\s*=\s*#{networkconfig['device']}/m) }
                it { is_expected.to contain_file("#{onehome}/etc/kickstart.d/rnr.ks").with_content(/context/m) }
                it { is_expected.to contain_file("#{onehome}/etc/kickstart.d/rnr.ks").with_content(/device\s*=\s*#{networkconfig['device']}/m) }
                it { is_expected.to contain_file("#{onehome}/etc/kickstart.d/rnr.ks").with_content(/part \/foo --fstype=ext4 --size=10000/) }
                it { is_expected.to contain_file("#{onehome}/etc/kickstart.d/rnr.ks").with_content(/repo --name="puppet" --baseurl=http:\/\/yum-repo.example.com\/puppet\//) }
                it { is_expected.to contain_file("#{onehome}/etc/kickstart.d/rnr.ks").with_content(/repo --name="one" --baseurl=http:/) }
              end
              context 'with preseed for Debian' do
                it { is_expected.to contain_file("#{onehome}/etc/preseed.d/does.cfg").with(
                    {
                      'content' => /ftp.us.debian.org/,
                      'owner' => 'oneadmin',
                      'group' => 'oneadmin',
                    },
                )}
              end
            end
          end
          context 'as oned' do
            let(:params) { {
              oned: true,
              node: false,
            } }
            sshprivkey = hiera.lookup('one::head::ssh_priv_key', nil, nil)
            sshpubkey = hiera.lookup('one::head::ssh_pub_key', nil, nil)
            it { is_expected.to contain_class('one::oned') }
            it { is_expected.to contain_class('one::oned::install') }
            it { is_expected.to contain_class('one::oned::config') }
            it { is_expected.to contain_class('one::oned::service') }
            it { is_expected.to contain_package('opennebula') }
            if os_facts[:osfamily] == 'RedHat'
              it { is_expected.to contain_package('opennebula-server') }
              it { is_expected.to contain_package('opennebula-ruby') }
            elsif os_facts[:osfamily] == 'Debian'
              it { is_expected.to contain_package('opennebula-tools') }
              it { is_expected.to contain_package('ruby-opennebula') }
            end
            it { is_expected.to contain_file("#{onehome}/.ssh/id_dsa").with_content(sshprivkey) }
            it { is_expected.to contain_file("#{onehome}/.ssh/id_dsa.pub").with_content(sshpubkey) }
            it { is_expected.to contain_file("#{onehome}/.ssh/authorized_keys").with_content(sshpubkey) }
            it { is_expected.to contain_file(oned_config).with_content(/^LOG = \[\n\s+system\s+=\s+"file"/m) }
            context 'with syslog logging' do
              let(:params) { {
                oned: true,
                oned_log_system: 'syslog'
              } }
              it { is_expected.to contain_file(oned_config).with_content(/^LOG = \[\n\s+system\s+=\s+"syslog"/m) }
            end
            context 'with invalid logging subsystem' do
              let(:params) { {
                oned: true,
                oned_log_system: 'invalid'
              } }
              it do
                is_expected.to compile.and_raise_error(/"invalid" is not a valid logging subsystem. Valid values are \["file", "syslog"\]/)
              end
            end
            context 'with sqlite backend' do
              it { is_expected.to contain_file(oned_config).with_content(/^DB = \[ backend = \"sqlite\"/) }
            end
            context 'with mysql backend' do
              let(:params) { {
                oned: true,
                backend: 'mysql'
              } }
              it { is_expected.to contain_file(oned_config).with_content(/^DB = \[ backend = \"mysql\"/) }
              it { is_expected.to contain_file(hiera.lookup('one::oned::backup::script_path', nil, nil)).with_content(/mysqldump/m) }
              it { is_expected.to contain_cron('one_db_backup').with(
                {
                  'command' => hiera.lookup('one::oned::backup::script_path', nil, nil),
                  'user' => hiera.lookup('one::oned::backup::db_user', nil, nil),
                  'target' => hiera.lookup('one::oned::backup::db_user', nil, nil),
                  'minute' => hiera.lookup('one::oned::backup::intervall', nil, nil),
                },
              )}
              it { is_expected.to contain_file(hiera.lookup('one::oned::backup::dir', nil, nil)).with_ensure('directory') }
            end
            context 'with wrong backend' do
              let(:params) { {
                oned: true,
                backend: 'foobar'
              } }
              it { expect { is_expected.to contain_class('one::oned') }.to raise_error(Puppet::Error) }
            end
            context 'with xmlrpc tuning' do
              it { is_expected.to contain_file('/etc/one/oned.conf').with_content(/MAX_CONN           = 5000/) }
            end
            context 'with hookscripts configured in oned.conf' do
              expected_vm_hook = %q{
            VM_HOOK = \[
              name      = "dnsupdate",
              on        = "CREATE",
              command   = "\/usr\/share\/one\/hooks\/dnsupdate\.sh",
              arguments = "\$TEMPLATE",
              remote    = "no" \]
            VM_HOOK = \[
              name      = "dnsupdate_custom",
              on        = "CUSTOM",
              state     = "PENDING",
              lcm_state = "LCM_INIT",
              command   = "\/usr\/share\/one\/hooks\/dnsupdate\.sh",
              arguments = "\$TEMPLATE",
              remote    = "no" \]
          }
              expected_host_hook = %q{
            HOST_HOOK = \[
              name      = "error",
              on        = "ERROR",
              command   = "ft\/host_error.rb",
              arguments = "\$ID -r",
              remote    = "no" \]
          }
              # Check for correct template replacement but ignore whitspaces and stuff.
              # Hint for editing: with %q{} only escaping of doublequote is not needed.
              expected_vm_hook = expected_vm_hook.gsub(/\s+/, '\\s+')
              expected_host_hook = expected_host_hook.gsub(/\s+/, '\\s+')
              it { is_expected.to contain_file(oned_config).with_content(/^#{expected_vm_hook}/m) }
              it { is_expected.to contain_file(oned_config).with_content(/^#{expected_host_hook}/m) }
            end
            context 'with default hook scripts rolled out' do
              it { is_expected.to contain_file('/usr/share/one/hooks').with_source('puppet:///modules/one/hookscripts') }
              it { is_expected.not_to contain_file('/usr/share/one/hooks/tests').with_source('puppet:///modules/one/hookscripts/tests') }
            end
            context 'with hook scripts package defined' do
              it { is_expected.to contain_package('hook_vms') }
              it { is_expected.to contain_package('hook_hosts') }
            end
            context 'with oneflow' do
              let(:params) { {
                oneflow: true
              } }
              it { is_expected.to contain_class('one::oned::oneflow') }
              it { is_expected.to contain_class('one::oned::oneflow::install') }
              it { is_expected.to contain_class('one::oned::oneflow::config') }
              it { is_expected.to contain_class('one::oned::oneflow::service') }
              it { is_expected.to contain_package('opennebula-flow') }
              if os_facts[:osfamily] == 'RedHat'
                it { is_expected.to contain_package('rubygem-treetop') }
                it { is_expected.to contain_package('rubygem-polyglot') }
              elsif os_facts[:osfamily] == 'Debian'
                it { is_expected.to contain_package('ruby-treetop') }
                it { is_expected.to contain_package('ruby-polyglot') }
              end
              it { is_expected.to contain_service('opennebula-flow').with_ensure('running') }
            end
            context 'with onegate endpoint' do
              it { is_expected.to contain_file(oned_config).with_content(/^#ONEGATE_ENDPOINT = "http:\/\/frontend:5030"/m) }
              context 'given a onegate ip' do
                let(:params) do
                  {
                    'oned'            => true,
                    'oned_onegate_ip' => '127.0.0.1'
                  }
                end
                it { is_expected.to contain_file(oned_config).with_content(/^ONEGATE_ENDPOINT = "http:\/\/127\.0\.0\.1:5030"/m) }
              end
              context 'given a onegate endpoint' do
                let(:params) do
                  {
                    'oned'                  => true,
                    'oned_onegate_endpoint' => 'https://example.org:5030'
                  }
                end
                it { is_expected.to contain_file(oned_config).with_content(/^ONEGATE_ENDPOINT = "https:\/\/example\.org:5030"/m) }
              end
              context 'given both a onegate ip and a onegate endpoint' do
                let(:params) do
                  {
                    'oned'                  => true,
                    'oned_onegate_ip'       => '127.0.0.1',
                    'oned_onegate_endpoint' => 'https://example.org:5030'
                  }
                end
                it do
                  is_expected.to compile.and_raise_error(/You can't provide both oned_onegate_ip and oned_onegate_endpoint as parameter/)
                end
              end
            end
            context 'with onegate' do
              let(:params) { {
                onegate: true
              } }
              it { is_expected.to contain_class('one::oned::onegate') }
              it { is_expected.to contain_class('one::oned::onegate::install') }
              it { is_expected.to contain_class('one::oned::onegate::config') }
              it { is_expected.to contain_class('one::oned::onegate::service') }
              it { is_expected.to contain_package('opennebula-gate') }
              if os_facts[:osfamily] == 'RedHat'
                it { is_expected.to contain_package('rubygem-parse-cron') }
              elsif os_facts[:osfamily] == 'Debian'
                # it { is_expected.to contain_package('parse-cron') }
              end
              it { is_expected.to contain_service('opennebula-gate').with_ensure('running') }
              context 'with ha-setup' do
                let(:params) { {
                  onegate: true,
                  oneflow: true,
                  ha_setup: true
                } }
                it { is_expected.to contain_class('one::oned::onegate') }
                it { is_expected.to contain_service('opennebula-flow').with_enable(false) }
                it { is_expected.to contain_service('opennebula-flow').without_ensure }
                it { is_expected.to contain_service('opennebula-gate').with_enable(false) }
                it { is_expected.to contain_service('opennebula-gate').without_ensure }
              end 
            end
            context 'with sunstone' do
              let(:params) { {
                sunstone: true
              } }
              sunstone_config = "#{configdir}/sunstone-server.conf"
              it { is_expected.to contain_class('one::oned::sunstone') }
              it { is_expected.to contain_class('one::oned::sunstone::install') }
              it { is_expected.to contain_class('one::oned::sunstone::config') }
              it { is_expected.to contain_class('one::oned::sunstone::service') }
              it { is_expected.to contain_package('opennebula-sunstone') }
              it { is_expected.to contain_file("#{configdir}/sunstone-views.yaml").with_ensure('file') }
              it { is_expected.to contain_file('/usr/lib/one/sunstone').with_ensure('directory') }
              it { is_expected.to contain_file(sunstone_config) }
              it { is_expected.to contain_service('opennebula-sunstone').with_ensure('running').with_require('Service[opennebula]') }
              context 'with passenger' do
                let(:params) { {
                  sunstone: true,
                  sunstone_passenger: true
                } }
                it { is_expected.to contain_service('opennebula-sunstone').with_ensure('stopped').with_enable(false) }
              end
              context 'with ldap' do
                let(:params) { {
                  oned: true,
                  sunstone: true,
                  ldap: true
                } }
                ldap_config = "#{configdir}/auth/ldap_auth.conf"
                it { is_expected.to contain_class('one::oned::sunstone::ldap') }
                it { is_expected.to contain_package('ruby-ldap') }
                if os_facts[:osfamily] == 'RedHat'
                  it { is_expected.to contain_package('rubygem-net-ldap') }
                elsif os_facts[:osfamily] == 'Debian'
                  it { is_expected.to contain_package('ruby-net-ldap') }
                end
                it { is_expected.to contain_file(ldap_config).with_content(/secure_password/) }
                it { is_expected.to contain_file(ldap_config).with_content(/\:encryption\: \:simple_tls/) }
                it { is_expected.to contain_file('/var/lib/one/remotes/auth/default').with_ensure('link') }
              end
              context 'with wrong ldap' do
                let(:params) { {
                  oned: true,
                  sunstone: true,
                  ldap: 'foobar'
                } }
                it { expect { is_expected.to contain_class('one::oned') }.to raise_error(Puppet::Error) }
              end
              context 'with ha' do
                let(:params) { {
                  oned: true,
                  sunstone: true,
                  ha_setup: true
                } }
                it { is_expected.to contain_service('opennebula').with_enable('false') }
                it { is_expected.to contain_service('opennebula-sunstone').with_ensure('running') }
              end
            end
          end
        end
      end
    end
  end
end
