# == Class one::params
#
# Installation and Configuration of OpenNebula
# http://opennebula.org/
#
# Sets required variables
# read some data from hiera, but also has defaults.
#
# === Author
# ePost Development GmbH
# (c) 2013
#
# Contributors:
# - Martin Alfke
# - Achim Ledermueller (Netways GmbH)
# - Sebastian Saemann (Netways GmbH)
# - Stephane Gerard (Vrije Universiteit Brussel)
#
# === License
# Apache License Version 2.0
# http://www.apache.org/licenses/LICENSE-2.0.html
#
class one::params {
  # SSH Key
  $ssh_priv_key_param        = lookup('one::head::ssh_priv_key', undef, undef, '')
  $ssh_pub_key               = lookup('one::head::ssh_pub_key', undef, undef, '')

  # package ensure, default true
  $package_ensure_latest = true

  #
  # hook script installation
  #
  # Alternative 1: Put the scripts into a puppet module.
  # Allows it to be overwritten by custom puppet profile
  # Should be the path to the folder which should be the source for the hookscripts on the puppetmaster
  # Default is a folder with an empty sample_hook.py
  #$hook_scripts_path = lookup('one::head::hook_script_path', undef, undef, 'puppet:///modules/one/hookscripts')

  # Alternative 2: Define package(s) which install the hook scripts.
  # This should be the preferred way.
  #$hook_scripts_pkgs = lookup('one::head::hook_script_pkgs', undef, undef, [])

  # Configuration for VM_HOOK and HOST_HOOK in oned.conf.
  # Activate and configure the hook scripts delivered via $hook_scripts_path or $hook_scripts_pkgs.
  #$hook_scripts      = lookup('one::head::hook_scripts', undef, undef, {})
  $vm_hook_scripts   = lookup('one::head::vm_hook_scripts', undef, undef, {})
  $host_hook_scripts = lookup('one::head::host_hook_scripts', undef, undef, {})

  # E-POST imaginator parameters
  $kickstart_network         = lookup ('one::node::kickstart::network', undef, undef, '')
  $kickstart_partition       = lookup ('one::node::kickstart::partition', undef, undef, '')
  $kickstart_rootpw          = lookup ('one::node::kickstart::rootpw', undef, undef, '')
  $kickstart_data            = lookup ('one::node::kickstart::data', undef, undef, {})
  $kickstart_tmpl            = lookup ('one::node::kickstart::kickstart_tmpl', undef, undef, 'one/kickstart.ks.erb')

  $preseed_data              = lookup ('one::node::preseed::data', undef, undef, {})
  $preseed_debian_mirror_url = lookup ('one::node::preseed::debian_mirror_url', undef, undef, 'http://ftp.debian.org/debian')
  $preseed_ohd_deb_repo      = lookup ('one::node::preseed::ohd_deb_repo', undef, undef, '')
  $preseed_tmpl              = lookup ('one::node::preseed::preseed_tmpl', undef, undef, 'one/preseed.cfg.erb')

  # OpenNebula DB backup parameters
  $backup_script_path        = lookup ('one::oned::backup::script_path', undef, undef, '/var/lib/one/bin/one_db_backup.sh')
  $backup_dir                = lookup ('one::oned::backup::dir', undef, undef, '/srv/backup')
  $backup_opts               = lookup ('one::oned::backup::opts', undef, undef, '-C -q -e')
  $backup_db                 = lookup ('one::oned::backup::db', undef, undef, 'oned')
  $backup_db_user            = lookup ('one::oned::backup::db_user', undef, undef, 'onebackup')
  $backup_db_password        = lookup ('one::oned::backup::db_password', undef, undef, 'onebackup')
  $backup_db_host            = lookup ('one::oned::backup::db_host', undef, undef, 'localhost')
  $backup_intervall          = lookup ('one::oned::backup::intervall', undef, undef, '*/10')
  $backup_keep               = lookup ('one::oned::backup::keep', undef, undef, '-mtime +15')

  # OpenNebula Oneflow parameters
  $oneflow_one_xmlrpc       = lookup ('one::oned::oneflow_one_xmlrpc', undef, undef, 'http://localhost:2633/RPC2')
  $oneflow_lcm_interval     = lookup ('one::oned::oneflow_lcm_interval', undef, undef, 30)
  $oneflow_host             = lookup ('one::oned::oneflow_host', undef, undef, '127.0.0.1')
  $oneflow_port             = lookup ('one::oned::oneflow_port', undef, undef, 2474)
  $oneflow_default_cooldown = lookup ('one::oned::oneflow_default_cooldown', undef, undef, 300)
  $oneflow_shutdown_action  = lookup ('one::oned::oneflow_shutdown_action', undef, undef, 'terminate')
  $oneflow_action_number    = lookup ('one::oned::oneflow_action_number', undef, undef, 1)
  $oneflow_action_period    = lookup ('one::oned::oneflow_action_period', undef, undef, 60)
  $oneflow_vm_name_template = lookup ('one::oned::oneflow_vm_name_template', undef, undef, '$ROLE_NAME_$VM_NUMBER_(service_$SERVICE_ID)')
  $oneflow_core_auth        = lookup ('one::oned::oneflow_core_auth', undef, undef, 'cipher')
  $oneflow_debug_level      = lookup ('one::oned::oneflow_debug_level', undef, undef, 2)

  # Where to place the sudo rule files
  $oneadmin_sudoers_file   = '/etc/sudoers.d/10_oneadmin'
  $imaginator_sudoers_file = '/etc/sudoers.d/20_imaginator'

  # OS specific params for nodes
  $oneversion = lookup('one::one_version', undef, undef, '6.6')
  case $facts['os']['family'] {
    'RedHat': {
      if $facts['os']['release']['major'] >= '7' {
        $node_packages = [
          'device-mapper-libs',
          'opennebula-node-kvm',
          'ipset',
        ]
      } else {
        $node_packages = [
          'device-mapper-libs',
          'opennebula-node-kvm',
          'python-virtinst',
          'ipset',
        ]
      }
      if ( versioncmp($oneversion, '6.0') >= 0 ) {
        $oned_packages   = ['opennebula', 'opennebula-rubygems', 'opennebula-tools']
      } else {
        $oned_packages   = ['opennebula', 'opennebula-server', 'opennebula-ruby']
      }
      $dbus_srv        = 'messagebus'
      $dbus_pkg        = 'dbus'
      $oned_sunstone_packages = ['opennebula-sunstone']

      $oned_sunstone_ldap_pkg = ['ruby-ldap','rubygem-net-ldap']
      # params for oneflow (optional, needs one::oneflow set to true)
      $oned_oneflow_packages = [
        'opennebula-flow',
        'rubygem-treetop',
        'rubygem-polyglot',
      ]
      # params for onegate (optional, needs one::onegate set to true)
      $oned_onegate_packages = ['opennebula-gate']
      $libvirtd_srv    = 'libvirtd'
      $libvirtd_cfg    = '/etc/sysconfig/libvirtd'
      $libvirtd_source = 'one/libvirtd.sysconfig.erb'
      $use_gems        = str2bool(lookup('one::oned::install::use_gems', undef, undef, 'true')) # lint:ignore:quoted_booleans
      $rubygems        = ['builder', 'sinatra']
      $rubygems_rpm    = ['rubygem-builder', 'rubygem-sinatra']
    }
    'Debian': {
      $use_gems        = true
      $node_packages   = [
        'opennebula-node',
        'virtinst',
        'ipset',
      ]
      $rubygems       = ['parse-cron', 'builder', 'sinatra']
      $oned_packages   = ['opennebula', 'opennebula-tools', 'ruby-opennebula']
      if ( versioncmp($oneversion, '6.0') >= 0 ) {
        $oned_packages   = ['opennebula', 'opennebula-rubygems', 'opennebula-tools']
      } else {
        $oned_packages   = ['opennebula', 'opennebula-tools', 'ruby-opennebula']
      }
      $dbus_srv        = 'dbus'
      $dbus_pkg        = 'dbus'
      $oned_sunstone_packages = 'opennebula-sunstone'
      $oned_sunstone_ldap_pkg = ['ruby-ldap','ruby-net-ldap']
      $oned_oneflow_packages = [
        'opennebula-flow',
        'ruby-treetop',
        'ruby-polyglot',
      ]
      $oned_onegate_packages = ['opennebula-gate']
      $libvirtd_srv = 'libvirt-bin'
      $libvirtd_cfg = '/etc/default/libvirt-bin'
      $libvirtd_source = 'one/libvirt-bin.debian.erb'
    }
    default: {
      fail("Your OS - ${facts['os']['family']} - is not yet supported. Please add required functionality to params.pp")
    }
  }
}
