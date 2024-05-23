require 'spec_helper'

hiera_config = 'spec/fixtures/hiera/hiera.yaml'

describe 'one::compute_node::config', type: :class do
  on_supported_os.each do |os, os_facts|
    context "On #{os}" do
      let(:facts) { os_facts }
      let(:params) { {
          debian_mirror_url:        'http://ftp.de.debian.org/debian',
          preseed_data:             {'does' => 'not_matter'},
          libvirtd_cfg:             '/etc/some/libvirt/config',
          oneadmin_sudoers_file:    '/etc/test-sudoers.d/10_oneadmin',
          imaginator_sudoers_file:  '/etc/test-sudoers.d/20_imaginator',
          manage_sudoer_config:     true
      } }
      it { should contain_class('one::compute_node::config') }
      it { should contain_file('/etc/libvirt/libvirtd.conf') }
      it { should contain_file('/etc/some/libvirt/config') }
      it { should contain_file('/etc/udev/rules.d/80-kvm.rules') }
      it { should contain_file('/etc/test-sudoers.d/10_oneadmin') }
      it { should contain_file('/etc/test-sudoers.d/20_imaginator') }
      if os_facts[:osfamily] == 'Debian'
        it { should contain_file('polkit-opennebula') \
            .with_path('/var/lib/polkit-1/localauthority/50-local.d/50-org.libvirt.unix.manage-opennebula.pkla')
        }
      elsif os_facts[:osfamily] == 'RedHat'
        it { should contain_file('polkit-opennebula') \
            .with_path('/etc/polkit-1/localauthority/50-local.d/50-org.libvirt.unix.manage-opennebula.pkla')
        }
      end
      context "with disabled sudoer management" do
        let(:params) { {
            debian_mirror_url:        'http://ftp.de.debian.org/debian',
            preseed_data:             {'does' => 'not_matter'},
            libvirtd_cfg:             '/etc/some/libvirt/config',
            oneadmin_sudoers_file:    '/etc/test-sudoers.d/10_oneadmin',
            imaginator_sudoers_file:  '/etc/test-sudoers.d/20_imaginator',
            manage_sudoer_config:     false
        } }
        it { should_not contain_file('/etc/test-sudoers.d/10_oneadmin') }
        it { should_not contain_file('/etc/test-sudoers.d/20_imaginator') }
      end
    end
  end
end
