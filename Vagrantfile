# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'
OS_RELEASE_MAJOR = '9'
PUPPET_RELEASE_MAJOR = '8'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "eurolinux-vagrant/rocky-#{OS_RELEASE_MAJOR}"
  config.vm.box_check_update = false

  # Litmus installs the module itself; do not share the repository into the VM.
  config.vm.synced_folder '.', '/vagrant', disabled: true

  config.vm.define 'one-acceptance' do |node|
    node.vm.hostname = 'one-acceptance.example.test'
    node.vm.network 'private_network', type: 'dhcp'

    node.vm.provider :libvirt do |libvirt|
      libvirt.driver = 'kvm'
      libvirt.qemu_use_session = false
      libvirt.memory = 8192
      libvirt.cpus = 4
      libvirt.machine_virtual_size = 80
    end

    node.vm.provision 'shell', inline: <<-SHELL
      set -e
      rpm -q puppet#{PUPPET_RELEASE_MAJOR}-release >/dev/null 2>&1 || \
        rpm -Uvh https://yum.puppet.com/puppet#{PUPPET_RELEASE_MAJOR}-release-el-#{OS_RELEASE_MAJOR}.noarch.rpm
      dnf install -y epel-release dnf-plugins-core
      dnf config-manager --set-enabled crb
      dnf install -y tar hostname openssh-server
      dnf install -y puppet-agent
      dnf install -y gcc gcc-c++ make libxml2-devel libxslt-devel patch
      /opt/puppetlabs/puppet/bin/gem install nokogiri --no-document
      /opt/puppetlabs/bin/puppet module install puppetlabs-stdlib --version 8.6.0
      /opt/puppetlabs/bin/puppet module install puppetlabs-inifile --version 5.4.1
      /opt/puppetlabs/bin/puppet module install puppetlabs-yumrepo_core --version 2.1.0
      /opt/puppetlabs/bin/puppet module install puppetlabs-cron_core --version 1.3.0
      install -d -m 0700 /root/.ssh
      cp /home/vagrant/.ssh/authorized_keys /root/.ssh/authorized_keys
      chmod 0600 /root/.ssh/authorized_keys
      systemctl enable sshd
      dnf clean all
    SHELL
  end
end
