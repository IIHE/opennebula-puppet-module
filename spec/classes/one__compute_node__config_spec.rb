require 'spec_helper'

describe 'one::compute_node::config', type: :class do
  on_supported_os.each do |os, os_facts|
    context "On #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { "service { 'libvirtd': }" }
      let(:params) do
        {
          libvirtd_cfg: '/etc/some/libvirt/config',
          libvirtd_source: 'one/libvirtd.sysconfig.erb',
          libvirtd_srv: 'libvirtd',
          oneadmin_sudoers_file: '/etc/test-sudoers.d/10_oneadmin',
          manage_sudoer_config: true,
        }
      end

      it { is_expected.to contain_class('one::compute_node::config') }
      it { is_expected.to contain_file('/etc/libvirt/libvirtd.conf') }
      it { is_expected.to contain_file('/etc/some/libvirt/config') }
      it { is_expected.to contain_file('/etc/udev/rules.d/80-kvm.rules') }
      it { is_expected.to contain_file('/etc/libvirt/qemu.conf') }
      it { is_expected.to contain_file('/etc/test-sudoers.d/10_oneadmin') }
      it { is_expected.to contain_file('/var/lib/one/.virtinst').with_ensure('directory') }
      it { is_expected.to contain_file('/var/lib/one/.libvirt').with_ensure('directory') }
      it { is_expected.to contain_file('/var/lib/libvirt/boot').with_mode('0771') }

      it do
        is_expected.to contain_file('polkit-opennebula')
          .with_path('/etc/polkit-1/localauthority/50-local.d/50-org.libvirt.unix.manage-opennebula.pkla')
      end

      context 'with disabled sudoer management' do
        let(:params) do
          {
            libvirtd_cfg: '/etc/some/libvirt/config',
            libvirtd_source: 'one/libvirtd.sysconfig.erb',
            libvirtd_srv: 'libvirtd',
            oneadmin_sudoers_file: '/etc/test-sudoers.d/10_oneadmin',
            manage_sudoer_config: false,
          }
        end

        it { is_expected.not_to contain_file('/etc/test-sudoers.d/10_oneadmin') }
      end
    end
  end
end
