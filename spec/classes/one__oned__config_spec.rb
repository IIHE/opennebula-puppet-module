require 'spec_helper'

hiera_config = 'spec/fixtures/hiera/hiera.yaml'

describe 'one::oned::config' do
  on_supported_os.each do |os, os_facts|
    context "On #{os}" do
      let(:facts) { os_facts }
      let (:hiera_config) { hiera_config }
      let (:pre_condition) { 'include one' }

      context 'general' do
        it { should contain_class('one::oned::config') }
        it { should contain_file('/etc/one/oned.conf') \
          .with_ensure('file')\
          .with_owner('root') \
          .with_mode('0640')
        }
        it { should contain_file('/etc/one/sched.conf') \
          .with_ensure('file')\
          .with_owner('root') \
          .with_mode('0640')
        }
        it { should contain_file('/usr/share/one/hooks') \
          .with_ensure('directory') \
          .with_mode('0750')
        }
        it { should contain_file('/usr/share/one').with_ensure('directory') }
      end

      context 'with mysql backend' do
        let (:params) { {
          backend: 'mysql',
          backup_script_path: '/var/lib/one/bin/one_db_backup.sh',
          backup_dir: '/srv/backup'
        } }
        it { should contain_file('/srv/backup') }
        it { should contain_file('/var/lib/one/bin/one_db_backup.sh') }
        it { should contain_cron('one_db_backup') }
      end

      context 'without kvm driver emulator settings' do
        it { should_not contain_ini_setting('set_kvm_driver_emulator') }
      end

      context 'with kvm driver emulator settings' do
        let(:params) { {
          kvm_driver_emulator: '/usr/bin/foobar/kvm-bogus'
        } }
        it { should contain_ini_setting('set_kvm_driver_emulator').with_value('/usr/bin/foobar/kvm-bogus') }
      end

      context 'without kvm driver nic settings' do
        it { should_not contain_ini_setting('set_kvm_driver_nic') }
      end

      context 'with kvm driver nic settings' do
        let(:params) { {
          kvm_driver_nic_attrs: '[ filter="clean-traffic", model="bogus" ]'
        } }
        it { should contain_ini_setting('set_kvm_driver_nic').with_value('[ filter="clean-traffic", model="bogus" ]') }
      end
    end
  end
end
