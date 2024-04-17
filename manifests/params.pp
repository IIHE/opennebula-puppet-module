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
#
# === License
# Apache License Version 2.0
# http://www.apache.org/licenses/LICENSE-2.0.html
#
class one::params {
  # OpenNebula parameters
  $oned_log_system     = lookup('one::oned::oned_log_system', undef, undef, 'file')
  $oned_port           = lookup('one::oned::port', undef, undef, '2633')
  $oned_listen_address = lookup('one::oned_listen_address', undef, undef, '0.0.0.0')
  $oned_db             = lookup('one::oned::db', undef, undef, 'oned')
  $oned_db_user        = lookup('one::oned::db_user', undef, undef, 'oned')
  $oned_db_password    = lookup('one::oned::db_password', undef, undef, 'oned')
  $oned_db_host        = lookup('one::oned::db_host', undef, undef, 'localhost')
  # default auth parameter - if needed for override
  $oned_default_auth = lookup('one::oned_default_auth', undef, undef, '')
  # ldap stuff (optional needs one::oned::ldap in hiera set to true)
  $oned_ldap_host = lookup('one::oned::ldap_host', undef, undef, 'ldap')
  $oned_ldap_port = lookup('one::oned::ldap_port', undef, undef, '636')
  $oned_ldap_base = lookup('one::oned::ldap_base', undef, undef, 'dc=example,dc=com')
  # $oned_ldap_user: can be empty if anonymous query is possible
  $oned_ldap_user = lookup('one::oned::ldap_user', undef, undef, 'cn=ldap_query,ou=user,dc=example,dc=com')
  $oned_ldap_pass = lookup('one::oned::ldap_pass', undef, undef, 'default_password')
  # $oned_ldap_group: can be empty, can be set to a group to restrict access to sunstone
  $oned_ldap_group = lookup( 'one::oned::ldap_group', undef, undef, '')
  # $oned_ldap_user_field: defaults to uid, can be set to the field, that holds the username in ldap
  $oned_ldap_user_field = lookup('one::oned::ldap_user_field', undef, undef, '')
  # $oned_ldap_group_field: default to member, can be set to the filed that holds the groupname
  $oned_ldap_group_field = lookup('one::oned::ldap_group_field', undef, undef, '')
  # $oned_ldap_user_group_field: default to dn, can be set to the user field that is in the group group_field
  $oned_ldap_user_group_field = lookup('one::oned::ldap_user_group_field', undef, undef, '')
  # ldap mapping options
  $oned_ldap_mapping_generate = lookup('one::oned::ldap_mapping_generate', undef, undef, '')
  $oned_ldap_mapping_timeout  = lookup('one::oned::ldap_mapping_timeout', undef, undef, 300)
  $oned_ldap_mapping_filename = lookup('one::oned::ldap_mapping_filename', undef, undef, "${facts['networking']['hostname']}.yaml")
  $oned_ldap_mapping_key      = lookup('one::oned::ldap_mapping_key', undef, undef, '')
  $oned_ldap_mapping_default  = lookup('one::oned::ldap_mapping_default', undef, undef, '')
  $oned_ldap_mappings         = lookup('one::oned::ldap_mappings', undef, undef, {})
  # should we enable opennebula repos?
  $one_repo_enable = lookup('one::enable_opennebula_repo', undef, undef, true)
  # Which version
  $one_version = lookup('one::one_version', undef, undef, '4.12')
  # should VM_SUBMIT_ON_HOLD be enabled in oned.conf?
  $oned_vm_submit_on_hold = lookup('one::oned::vm_submit_on_hold', undef, undef, 'NO')

  # SSH Key
  $ssh_priv_key_param        = lookup('one::head::ssh_priv_key', undef, undef, '')
  $ssh_pub_key               = lookup('one::head::ssh_pub_key', undef, undef, '')

  # OpenNebula XMLRPC tuning parameters
  $xmlrpc_maxconn            = lookup('one::oned::xmlrpc_maxconn', undef, undef, 15)
  $xmlrpc_maxconn_backlog    = lookup('one::oned::xmlrpc_maxconn_backlog', undef, undef, 15)
  $xmlrpc_keepalive_timeout  = lookup('one::oned::xmlrpc_keepalive_timeout', undef, undef, 15)
  $xmlrpc_keepalive_max_conn = lookup('one::oned::xmlrpc_keepalive_max_conn', undef, undef, 30)
  $xmlrpc_timeout            = lookup('one::oned::xmlrpc_timeout', undef, undef, 15)

  # OpenNebula INHERIT attrs
  # (NOTE: setting default to undef causes value to show up as "" in ERB
  # template for ruby 1.9.x)
  $inherit_datastore_attrs   = lookup('one::oned::inherit_datastore_attrs', undef, undef, [])

  # VLAN_IDS and VXLAN_IDS for OpenNebula Physical Networks
  # see oned.conf for more information
  $vlan_ids_start            = lookup('one::vlan_ids_start', undef, undef, '2')
  $vlan_ids_reserved         = lookup('one::vlan_ids_reserved', undef, undef, '0, 1, 4095')
  $vxlan_ids_start           = lookup('one::vxlan_ids_start', undef, undef, '2')

  # OpenNebula KVM driver parameters
  $kvm_driver_emulator       = lookup ('one::oned::kvm_driver_emulator', undef, undef, '' )
  $kvm_driver_nic_attrs      = lookup ('one::oned::kvm_driver_nic_attrs', undef, undef, '')

  # Sunstone configuration parameters
  $sunstone_listen_ip        = lookup('one::oned::sunstone_listen_ip', undef, undef, '127.0.0.1')
  $sunstone_logo_png         = lookup('one::oned::sunstone_logo_png', undef, undef, '')
  $sunstone_logo_small_png   = lookup('one::oned::sunstone_logo_small_png', undef, undef, '')
  $enable_support            = lookup('one::oned::enable_support', undef, undef, 'yes')
  $enable_marketplace        = lookup('one::oned::enable_marketplace', undef, undef, 'yes')
  $sunstone_tmpdir           = lookup('one::oned::sunstone_tmpdir', undef, undef, '/var/tmp')
  $sunstone_sessions         = lookup('one::oned::sunstone_sessions', undef, undef, 'memory')
  $vnc_proxy_port            = lookup('one::oned::vnc_proxy_port', undef, undef, '29876')
  $vnc_proxy_support_wss     = lookup('one::oned::vnc_proxy_support_wss', undef, undef, 'no')
  $vnc_proxy_cert            = lookup('one::oned::vnc_proxy_cert', undef, undef, '')
  $vnc_proxy_key             = lookup('one::oned::vnc_proxy_key', undef, undef, '')
  $vnc_proxy_ipv6            = lookup('one::oned::vnc_proxy_ipv6', undef, undef, 'false') # lint:ignore:quoted_booleans
  $sunstone_fireedge_priv_endpoint = lookup('one::sunstone_fireedge_priv_endpoint', undef, undef, 'http://localhost:2616')
  $sunstone_fireedge_pub_endpoint  = lookup('one::sunstone_fireedge_pub_endpoint', undef, undef, 'http://localhost:2616')

  # generic params for nodes and oned
  $oneuid = '9869'
  $onegid = '9869'

  # OpenNebula monitoring parameters
  $monitoring_interval            = lookup('one::oned::monitoring_interval', undef, undef, 60)
  $monitoring_interval_host       = lookup('one::oned::monitoring_interval_host', undef, undef, 180)
  $monitoring_interval_vm         = lookup('one::oned::monitoring_interval_vm', undef, undef, 180)
  $monitoring_interval_datastore  = lookup('one::oned::monitoring_interval_datastore', undef, undef, 300)
  $monitoring_interval_market     = lookup('one::oned::monitoring_interval_market', undef, undef, 600)
  $monitoring_threads             = lookup('one::oned::monitoring_threads', undef, undef, 50)
  $information_collector_interval = lookup('one::oned::information_collector_interval', undef, undef, 20)

  $http_proxy = lookup('one::oned::http_proxy', undef, undef, '')

  # package ensure, default true
  $package_ensure_latest = true

  #
  # hook script installation
  #
  # Alternative 1: Put the scripts into a puppet module.
  # Allows it to be overwritten by custom puppet profile
  # Should be the path to the folder which should be the source for the hookscripts on the puppetmaster
  # Default is a folder with an empty sample_hook.py
  $hook_scripts_path = lookup('one::head::hook_script_path', undef, undef, 'puppet:///modules/one/hookscripts')

  # Alternative 2: Define package(s) which install the hook scripts.
  # This should be the preferred way.
  $hook_scripts_pkgs = lookup('one::head::hook_script_pkgs', undef, undef, [])

  # Configuration for VM_HOOK and HOST_HOOK in oned.conf.
  # Activate and configure the hook scripts delivered via $hook_scripts_path or $hook_scripts_pkgs.
  $hook_scripts      = lookup('one::head::hook_scripts', undef, undef, {})
  $vm_hook_scripts   = lookup('one::head::vm_hook_scripts', undef, undef, {})
  $host_hook_scripts = lookup('one::head::host_hook_scripts', undef, undef, {})

  # Todo: Use Serviceip from HA-Setup if ha enabled.
  $oned_onegate_ip = lookup('one::oned::onegate::ip', undef, undef, '')
  # Specify full endpoint if needed (such as if using https proxy)
  $oned_onegate_endpoint = lookup('one::oned::onegate::endpoint', undef, undef, '')

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

  # OpenNebula Scheduler parameters
  $sched_interval            = lookup ('one::oned::sched::sched_interval', undef, undef, 30)
  $sched_max_vm              = lookup ('one::oned::sched::max_vm', undef, undef, 5000)
  $sched_max_dispatch        = lookup ('one::oned::sched::max_dispatch', undef, undef, 30)
  $sched_max_host            = lookup ('one::oned::sched::max_host', undef, undef, 1)
  $sched_live_rescheds       = lookup ('one::oned::sched::live_rescheds', undef, undef, 0)
  $sched_default_policy      = lookup ('one::oned::sched::default_policy', undef, undef, 1)
  $sched_default_rank        = lookup ('one::oned::sched::default_rank', undef, undef, '- (RUNNING_VMS * 50  + FREE_CPU)')
  $sched_default_ds_policy   = lookup ('one::oned::sched::default_ds_policy', undef, undef, 1)
  $sched_default_ds_rank     = lookup ('one::oned::sched::default_ds_rank', undef, undef, '')
  $sched_log_system          = lookup ('one::oned::sched::log_system', undef, undef, 'file')
  $sched_log_debug_level     = lookup ('one::oned::sched::log_debug_level', undef, undef, 3)

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

  # OpenNebula Datastore parameters
  $datastore_capacity_check    = lookup ('one::oned::datastore_capacity_check', undef, undef, 'yes')
  $default_image_type          = lookup ('one::oned::default_image_type', undef, undef, 'OS')
  $default_device_prefix       = lookup ('one::oned::default_device_prefix', undef, undef, 'hd')
  $default_cdrom_device_prefix = lookup ('one::oned::default_cdrom_device_prefix', undef, undef, 'hd')

  # Where to place the sudo rule files
  $oneadmin_sudoers_file   = '/etc/sudoers.d/10_oneadmin'
  $imaginator_sudoers_file = '/etc/sudoers.d/20_imaginator'

  # OS specific params for nodes
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
      if ( versioncmp($one_version, '6.0') >= 0 ) {
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
      if ( versioncmp($one_version, '6.0') >= 0 ) {
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
