require 'spec_helper'

describe 'one', type: :class do
  on_supported_os.each do |os, os_facts|
    context "On #{os}" do
      let(:facts) { os_facts }

      context 'with default parameters' do
        it { is_expected.to contain_class('one') }
        it { is_expected.to contain_class('one::prerequisites') }
        it { is_expected.to contain_class('one::install') }
        it { is_expected.to contain_class('one::config') }
        it { is_expected.to contain_class('one::service') }
        it { is_expected.not_to contain_class('one::oned') }
        it { is_expected.to contain_class('one::compute_node') }
        it { is_expected.to contain_package('dbus') }
        it { is_expected.to contain_file('/var/lib/one').with_ensure('directory').with_owner('oneadmin') }
        it { is_expected.to contain_file('/var/lib/one/.ssh/id_rsa').with_ensure('file') }
        it { is_expected.to contain_file('/var/lib/one/.ssh/id_rsa.pub').with_ensure('file') }
        it { is_expected.to contain_file('/var/lib/one/.ssh/authorized_keys').with_ensure('file') }
        it { is_expected.to contain_file('/etc/libvirt/qemu.conf').with_ensure('file') }
        it { is_expected.to contain_file('/etc/udev/rules.d/80-kvm.rules').with_ensure('file') }
        it { is_expected.to contain_package('opennebula-node-kvm') }
        it { is_expected.to contain_service('libvirtd').with_ensure('running') }
        it { is_expected.to contain_service('ksm').with_ensure('running') }
        it { is_expected.to contain_service('ksmtuned').with_ensure('stopped') }
      end

      context 'as oned' do
        let(:params) { { oned: true, workernode: false } }

        it { is_expected.to contain_class('one::oned') }
        it { is_expected.to contain_class('one::oned::install') }
        it { is_expected.to contain_class('one::oned::config') }
        it { is_expected.to contain_class('one::oned::service') }
        it { is_expected.to contain_package('opennebula') }
        it { is_expected.to contain_package('opennebula-rubygems') }
        it { is_expected.to contain_package('opennebula-tools') }
        it { is_expected.to contain_service('opennebula').with_ensure('running') }
        it { is_expected.to contain_file('/etc/one/oned.conf').with_ensure('file') }
        it { is_expected.to contain_file('/etc/one/oned.conf').with_content(/^DB = \[ BACKEND = "sqlite" \]/m) }
        it { is_expected.to contain_file('/etc/one/oned.conf').with_content(/^LOG = \[\n\s+SYSTEM\s+=\s+"file"/m) }
      end

      context 'with syslog logging' do
        let(:params) { { oned: true, workernode: false, oned_log_system: 'syslog' } }

        it { is_expected.to contain_file('/etc/one/oned.conf').with_content(/^LOG = \[\n\s+SYSTEM\s+=\s+"syslog"/m) }
      end

      context 'with an invalid logging subsystem' do
        let(:params) { { oned: true, workernode: false, oned_log_system: 'invalid' } }

        it do
          is_expected.to compile.and_raise_error(/"invalid" is not a valid logging subsystem/)
        end
      end

      context 'with a mysql backend' do
        let(:params) do
          {
            oned: true,
            workernode: false,
            backend: 'mysql',
            backup_script_path: '/var/lib/one/bin/one_db_backup.sh',
            backup_dir: '/srv/backup',
          }
        end

        it { is_expected.to contain_file('/etc/one/oned.conf').with_content(/^DB = \[ BACKEND = "mysql"/m) }
        it { is_expected.to contain_file('/srv/backup').with_ensure('directory') }
        it { is_expected.to contain_file('/var/lib/one/bin/one_db_backup.sh').with_content(/mysqldump/m) }
        it { is_expected.to contain_cron('one_db_backup') }
      end

      context 'with an invalid backend' do
        let(:params) { { oned: true, workernode: false, backend: 'foobar' } }

        it do
          is_expected.to compile.and_raise_error(/proper DB backend.*sqlite or mysql/m)
        end
      end

      context 'with sunstone and ONE 6.6' do
        let(:params) { { oned: true, sunstone: true, workernode: false } }

        it { is_expected.to contain_class('one::oned::sunstone') }
        it { is_expected.to contain_class('one::oned::sunstone::install') }
        it { is_expected.to contain_class('one::oned::sunstone::config') }
        it { is_expected.to contain_class('one::oned::sunstone::service') }
        it { is_expected.to contain_package('opennebula-sunstone') }
        it { is_expected.to contain_file('/etc/one/sunstone-server.conf').with_ensure('file') }
        it { is_expected.to contain_file('/etc/one/sunstone-views/mixed/admin.yaml').with_ensure('file') }
        it { is_expected.to contain_service('opennebula-sunstone').with_ensure('running') }
      end

      context 'with sunstone and ONE 7.4' do
        let(:params) do
          {
            oned: true,
            sunstone: true,
            workernode: false,
            one_version: '7.4',
          }
        end

        it { is_expected.to contain_package('opennebula-fireedge') }
        it { is_expected.to contain_package('opennebula-guacd') }
        it { is_expected.to contain_file('/etc/one/fireedge-server.conf').with_ensure('file') }
        it { is_expected.to contain_service('opennebula-fireedge').with_ensure('running') }
        it { is_expected.not_to contain_service('opennebula-sunstone') }
        it { is_expected.not_to contain_package('opennebula-sunstone') }
      end

      context 'with oneflow' do
        let(:params) { { oned: true, oneflow: true, workernode: false } }

        it { is_expected.to contain_class('one::oned::oneflow') }
        it { is_expected.to contain_class('one::oned::oneflow::install') }
        it { is_expected.to contain_class('one::oned::oneflow::config') }
        it { is_expected.to contain_class('one::oned::oneflow::service') }
        it { is_expected.to contain_package('opennebula-flow') }
        it { is_expected.to contain_service('opennebula-flow').with_ensure('running') }
      end

      context 'with onegate' do
        let(:params) { { oned: true, onegate: true, workernode: false } }

        it { is_expected.to contain_class('one::oned::onegate') }
        it { is_expected.to contain_class('one::oned::onegate::install') }
        it { is_expected.to contain_class('one::oned::onegate::config') }
        it { is_expected.to contain_class('one::oned::onegate::service') }
        it { is_expected.to contain_package('opennebula-gate') }
        it { is_expected.to contain_service('opennebula-gate').with_ensure('running') }
      end

      context 'with onegate endpoint settings' do
        context 'given a onegate ip' do
          let(:params) { { oned: true, workernode: false, oned_onegate_ip: '127.0.0.1' } }

          it { is_expected.to contain_file('/etc/one/oned.conf').with_content(/^ONEGATE_ENDPOINT = "http:\/\/127\.0\.0\.1:5030"/m) }
        end

        context 'given a onegate endpoint' do
          let(:params) { { oned: true, workernode: false, oned_onegate_endpoint: 'https://example.org:5030' } }

          it { is_expected.to contain_file('/etc/one/oned.conf').with_content(/^ONEGATE_ENDPOINT = "https:\/\/example\.org:5030"/m) }
        end

        context 'given both a onegate ip and a onegate endpoint' do
          let(:params) do
            {
              oned: true,
              workernode: false,
              oned_onegate_ip: '127.0.0.1',
              oned_onegate_endpoint: 'https://example.org:5030',
            }
          end

          it do
            is_expected.to compile.and_raise_error(/You can't provide both oned_onegate_ip and oned_onegate_endpoint/)
          end
        end
      end
    end
  end
end
