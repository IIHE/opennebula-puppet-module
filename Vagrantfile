# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'
OS_RELEASE_MAJOR = '8'
PUPPET_RELEASE_MAJOR='8'
PUPPET_REPO_URL = "https://yum.puppet.com/puppet#{PUPPET_RELEASE_MAJOR}-release-el-#{OS_RELEASE_MAJOR}.noarch.rpm"

# Check that required vagrant plugins are installed
["vagrant-hosts", "vagrant-libvirt"].each do |plugin|
  abort "Please install the #{plugin} Vagrant plugin with 'vagrant pluging install #{plugin}'" unless Vagrant.has_plugin?("#{plugin}")
end


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # using libvirt provider
  config.vm.provider :libvirt do |libvirt|
    libvirt.driver = 'kvm'
    libvirt.qemu_use_session = false
    libvirt.memory = 2048
    libvirt.cpus = 2
  end

  config.vm.network "private_network", type: "dhcp"

  config.vm.synced_folder '.', '/etc/puppet/modules/one/', type: nfs, nfs_version: 4, nfs_udp: false, mount_options: ['rw', 'vers=4', 'tcp', 'no_subtree_check', 'no_root_squash']

  config.vm.define 'rockylinux-head' do |centos|
    centos.vm.box = "eurolinux-vagrant/rocky-#{OS_RELEASE_MAJOR}"
    #config.vm.box_version = '1.0.1'
    centos.vm.provision :hosts, :sync_hosts => true
    centos.vm.provision 'shell', inline: "rpm -Uvh #{PUPPET_REPO_URL}"
    centos.vm.provision 'shell', inline: '/usr/bin/yum -y install epel-release'
    centos.vm.provision 'shell', inline: 'dnf install -y puppet-agent'
    centos.vm.provision 'shell', inline: 'puppet module install puppetlabs-stdlib'
    centos.vm.provision 'shell', inline: 'puppet module install puppetlabs-inifile'
    centos.vm.provision 'puppet' do |puppet|
      puppet.manifests_path = 'manifests'
      puppet.manifest_file = 'init.pp'
      puppet.options = [
          '--verbose',
          "-e 'class { one: oned => true, sunstone => true, }'"
      ]
    end
  end

  config.vm.define 'rockylinux-node' do |centos|
    centos.vm.box = "eurolinux-vagrant/rocky-#{OS_RELEASE_MAJOR}"
    #config.vm.box_version = '1.0.1'
    centos.vm.provision :hosts, :sync_hosts => true
    centos.vm.provision 'shell', inline: "rpm -Uvh #{PUPPET_REPO_URL}"
    centos.vm.provision 'shell', inline: '/usr/bin/yum -y install epel-release'
    centos.vm.provision 'shell', inline: 'dnf install -y puppet-agent'
    centos.vm.provision 'shell', inline: 'puppet module install puppetlabs-stdlib'
    centos.vm.provision 'shell', inline: 'puppet module install puppetlabs-inifile'
    centos.vm.provision 'puppet' do |puppet|
      puppet.manifests_path = 'manifests'
      puppet.manifest_file = 'init.pp'
      puppet.options = [
          '--verbose',
          "-e 'class { one: }'"
      ]
    end
  end

end
