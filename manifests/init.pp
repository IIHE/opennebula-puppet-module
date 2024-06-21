# == Class one
#
# Installation and Configuration of OpenNebula
# http://opennebula.org/
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
# === Parameters
#
# Convention for parameters:
# * parameters that are used in the generation of oned.conf are prefixed with oned_
# * parameters that are used in the generation of sunstone-server.conf are prefixed with sunstone_
# * parameters that are used in the generation of ldap_auth.conf are prefixed with ldap_
#
# ==== OpenNebula general parameters
#
# $oneid <string> - default to one-cloud
#   set the id of the cloud
#
# $workernode true|false - default true
#  defines whether the host is node (virtualization host/worker)
#
# $im_mad - default kvm
#  set Information Manager driver for opennebula compute node
#  supported types:
#   - kvm
#   - xen
#   - vmware
#   - ec2
#   - ganglia
#   - dummy
#
# $vm_mad - default kvm
#  set virtualization type for opennebula compute node
#  supported types:
#   - kvm
#   - xen
#   - vmware
#   - ec2
#   - dummy
#   - qemu
#
# $vn_mad - default 802.1Q
#  set network type for opennebula compute node
#  supported types:
#   - 802.1Q
#   - ebtables
#   - firewall
#   - ovswitch
#   - vmware
#   - dummy
#
# $oned true|false - default false
#   defines whether OpenNebula-Daemon should be installed.
#   OpenNebula-Daemon needs to run on the system where you want to manage your
#   OpenNebula systems.
#   You need exactly one OpenNebula Daemon in your infrastructure.
#
# $backend sqlite|mysql - default to sqlite
#   defines which backend should be used
#   supports sqlite or mysql
#   does not install mysql server, only uses information from params.pp
#
# $sunstone true|false - default false
#   defines where the Sunstone Webinterface should be installed.
#   Sunstone Webinterface is fully optional.
#
# $sunstone_passenger - default false
#   defines whether Sunstone Webinterface should be started by apache instead of webrick
#   needs separate apache config
#   only used if $sunstone is set to true
#
# $sunstone_novnc - default false
#   defines whether novnc should be started for sunstone web interface
#   fully optional and only used if $sunstone is set to true
#
# $sunstone_fireedge - default false
#   defines whether fireedge will be used
#   fully optional and only used if $sunstone is set to true
#
# $ldap true|false - default false
#   defines whether sunstone authentication to ldap should be enabled
#   ldap is fully optional
#
# $ha_setup true | false - default false
#   defines whether the oned should be run on boot
#
# $oneflow true|false - default false
#   defines whether the oneflow service should be installed
#
# $puppetdb true|false - default false
#   defines to use puppetDB to discover peer nodes (hypervisors)
#
# $debug_level - default 0
#   defines the debug level under which oned and sunstone are running
#
# ==== OpenNebula configuration parameters
#
# $oned_log_system - default 'file'
#   the log subsystem to use, valid values are [file, syslog]
#
# ===== OpenNebula Database configuration
#
# $oned_db - default oned
#   name of the oned database
#
# $oned_db_user - default oned
#   name of the database user
#
# $oned_db_password - default oned
#   password of the database user
#
# $oned_db_host - default localhost
#   oned database host
#
# ===== OpenNebula LDAP configuration
# optional needs $ldap set to true
#
# $ldap_host - default ldap
#   hostname of the ldap server
#
# $ldap_port - default 636
#   port of the ldap service
#
# $ldap_base - default dc=example,dc=com
#   ldap base
#
# $ldap_user - default cn=ldap_query,ou=user,dc=example,dc=com
#   ldap user for queries - can be empty if anonymous query is possible
#
# $ldap_pass - default default_password
#   ldap user password for queries - can be empty if anonymous query is possible
#
# $ldap_group - default undef
#   restrict access to certain groups - cen be undef to allow all user access
#
# $ldap_user_field - default undef
#   defaults to uid, can be set to the field, that holds the username in ldap
#
# $ldap_group_field - default undef
#   default to member, can be set to the filed that holds the groupname
#
# $ldap_user_group_field - default undef
#   default to dn, can be set to the user field that is in the group group_field
#
# ===== OpenNebula User configuration
#
# $oneuid - default 9869
#   set the oneadmin user id
#
# $onegid - default 9869
#   set the oneadmin group id
#
# $ssh_priv_key_param - default undef
#   add the private key to oneadmin user
#
# $ssh_pub_key - default undef
#   add public key to oneadmin user
#
# ===== OpenNebula XMLRPC configuration
#
# $xmlrpc_max_conn - default 15
#   set maximum number of connections
#
# $xmlrpc_maxconn_backlog - default 15
#   set maximum number of queued connections
#
# $xmlrpc_keepalive_timeout - default 15
#   set xmlrpc keepalive timeout in seconds
#
# $xmlrpc_keepalive_max_conn - default 30
#   set xmlrpc active connection timeout in seconds
#
# $xmlrpc_timeout - default 15
#   set xmlrpc timout in seconds
#
# ===== OpenNebula Sunstone configuration
#
# $sunstone_listen_ip - default 127.0.0.1
#   set the ip where sunstone interface should listen
#
# $sunstone_enable_support - default yes
#   enable support button in sunstone
#
# $sunstone_enable_marketplace - default yes
#   enable marketplace button in sunstone
#
# $sunstone_tmpdir - default /var/tmp
#   define a different tmp dir for sunstone
#
# $sunstone_logo_png - default use ONE logo
#   use custom logo on sunstone login page
#   used as the 'source' for image file resource
#   e.g. puppet:///modules/mymodule/my-custom-logo.png
#
# $sunstone_logo_small_png - default use ONE logo
#   use custom small logo in upper left corner of sunstone admin
#   used as the 'source' for image file resource
#   e.g. puppet:///modules/mymodule/my-custom-small-logo.png
#
# $sunstone_fireedge_priv_endpoint - default http://localhost:2616
#   url of the private fireedge endpoint for sunstone
#
# $sunstone_fireedge_pub_endpoint -default http://localhost:2616
#   url of the public fireedge endpoint for sunstone
#
# ===== OpenNebula host monitoring configuration
# $oned_monitoring_interval - default 60
#
# ===== These options are for OpenNebula >= 5.8
# $oned_monitoring_interval_host - default 180
# $oned_monitoring_interval_vm - default 180
# $oned_monitoring_interval_datastore - default 300
# $oned_monitoring_interval_market - default 600
#   when should monitoring start again in seconds
#
# $oned_monitoring_threads - default 50
#   how many monitoring threads should be started
#
# $oned_information_collector_interval - default 20
#   how often should monitoring data get collected
#
# ===== OpenNebula Hook Script configuration
#
# hook scripts can either be placed in puppet or in a package
#
# $hook_scripts - default undef
#   should hook script be installed
#   either undef or a hash. two keys are supported:
#       - VM - VM hook scripts
#       - HOST - HOST hook scripts
#   hiera data example:
#        # Configures the hook scripts for VM and HOST in oned.conf
#        one::head::hook_scripts:
#          VM:
#            dnsupdate:
#              state:      'CREATE'
#              command:    '/usr/share/one/hooks/dnsupdate.sh'
#              arguments:  '$TEMPLATE'
#              remote:      'no'
#            dnsupdate_custom:
#              state:        'CUSTOM'
#              custom_state: 'PENDING'
#              lcm_state:    'LCM_INIT'
#              command:    '/usr/share/one/hooks/dnsupdate.sh'
#              arguments:  '$TEMPLATE'
#              remote:      'no'
#          HOST:
#            error:
#              state:      'ERROR'
#              command:    'ft/host_error.rb'
#              arguments:  '$ID -r'
#              remote:      'no'
#
# $hook_scripts_path - default puppet:///modules/one/hookscripts
#   path where puppet will look for hook scripts
#
# $hook_scripts_pkgs - default undef
#   package which will have the hook scripts
#   hiera data example:
#        #Install additional packages which contains the hook scripts
#        one::head::hook_script_pkgs:
#            - 'hook_vms'
#            - 'hook_hosts'
#
# ===== OpenNebula OneGate configuration
#
# $oned_onegate_ip - default undef
#   which ip should the onegate daemon listen on
#
# ==== Imaginator configuration
#
# $kickstart_network - default undef
# $kickstart_partition - default undef
# $kickstart_rootpw - default undef
# $kickstart_data - default undef
# $kickstart_tmpl - default one/kickstart.ks.erb
# $preseed_data - default {}
# $preseed_debian_mirror_url - default http://ftp.debian.org/debian
# $preseed_ohd_deb_repo - default undef
# $preseed_tmpl - default  one/preseed.cfg.erb
#
# ==== Database Backup configuration
#
# $backup_script_path - default /var/lib/one/bin/one_db_backup.sh
# $backup_dir - default /srv/backup
# $backup_opts - default -C -q -e
# $backup_db - default oned
# $backup_db_user - default onebackup
# $backup_db_password - default onebackup
# $backup_db_host - default localhost
# $backup_intervall - default */10
# $backup_keep - default -mtime +15
#
# ==== OS specific configuration
#
# set in manifests/params for each os.
#
# $node_packages
# $oned_packages
# $dbus_srv
# $dbus_pkg
# $oned_sunstone_packages
# $oned_sunstone_ldap_pkg
# $oned_oneflow_packages
# $oned_onegate_packages
# $libvirtd_srv
# $libvirtd_cfg
# $libvirtd_source
# $rubygems
#
# $manage_sudoer_config - default true, set false to disable management of the sudoer
#                         config. you'll have to manage the config yourself then
# $oneadmin_sudoers_file - default '/etc/sudoers.d/10_oneadmin'
#   where to place the file with the oneadmin sudoer rules
# $imaginator_sudoers_file - default '/etc/sudoers.d/20_imaginator'
#   where to place the file with the imaginator sudoer rules
#
# ==== Environment specific configuration
#
# $http_proxy - default ''
#   set to proxy if you can not install gems directly
#
# $repo_enable - default true
#   should the official opennebula repositories be enabled?
#
# $package_ensure_latest - default true
#   if true then all package declarations will be set latest
#   if false they will be set present (use if using ha_setup as the service
#     will not be restarted after installing the package)
#
# === Usage
#
# install compute node
# class { one: }
#
# install opennebula management node (without sunstone webinterface)
# class { one: oned => true }
#
# install opennebula management node with sunstone webinterface
# class { one:
#   oned => true,
#   sunstone => true,
# }
#
# install opennebula sunstone webinterface only
# class { one: sunstone => true }
#
# installation of optional oneflow and onegate requires oned.
# class { one:
#   oned => true,
#   oneflow => true,
#   onegate => true,
# }
#
# === License
# Apache License Version 2.0
# http://www.apache.org/licenses/LICENSE-2.0.html
#
class one (
  String $oneid                                 = 'one-cloud',
  Boolean $workernode                           = true,
  String $im_mad                                = 'kvm',
  String $vm_mad                                = 'kvm',
  String $vn_mad                                = '802.1Q',
  Boolean $oned                                 = false,
  Boolean $sunstone                             = false,
  Boolean $sunstone_passenger                   = false,
  Boolean $sunstone_novnc                       = false,
  Boolean $sunstone_fireedge                    = false,
  Boolean $ldap                                 = false,
  Boolean $oneflow                              = false,
  Boolean $onegate                              = false,
  String $backend                               = 'sqlite',
  Boolean $ha_setup                             = false,
  Boolean $puppetdb                             = false,
  String $debug_level                           = '0',
  String $oned_listen_address                   = '0.0.0.0',
  String $oned_log_system                       = 'file',
  String $oned_port                             = '2633',
  String $oned_db                               = 'oned',
  String $oned_db_user                          = 'oned',
  String $oned_db_password                      = 'oned',
  String $oned_db_host                          = 'localhost',
  String $oned_vm_submit_on_hold                = 'NO',
  String $oned_default_auth                     = 'default',
  String $ldap_host                             = 'ldap',
  String $ldap_port                             = '636',
  String $ldap_base                             = 'dc=example,dc=com',
  String $ldap_user                             = 'cn=ldap_query,ou=user,dc=example,dc=com',
  String $ldap_pass                             = 'default_password',
  String $ldap_group                            = '',
  String $ldap_user_field                       = '',
  String $ldap_group_field                      = '',
  String $ldap_user_group_field                 = '',
  Boolean $ldap_mapping_generate                = false,
  Integer $ldap_mapping_timeout                 = 300,
  String $ldap_mapping_filename                 = "${facts['networking']['hostname']}.yaml",
  Hash $ldap_mappings                           = {},
  String $ldap_mapping_key                      = '',
  String $ldap_mapping_default                  = '',
  Boolean $repo_enable                          = true,
  String $ssh_priv_key_param                    = $one::params::ssh_priv_key_param,
  String $ssh_pub_key                           = $one::params::ssh_pub_key,
  Integer $oned_xmlrpc_maxconn                  = 15,
  Integer $oned_xmlrpc_maxconn_backlog          = 15,
  Integer $oned_xmlrpc_keepalive_timeout        = 15,
  Integer $oned_xmlrpc_keepalive_max_conn       = 30,
  Integer $oned_xmlrpc_timeout                  = 15,
  String $sunstone_listen_ip                    = '127.0.0.1',
  String $sunstone_logo_png                     = '',
  String $sunstone_logo_small_png               = '',
  String $sunstone_enable_support               = 'yes',
  String $sunstone_enable_marketplace           = 'yes',
  String $sunstone_tmpdir                       = '/var/tmp',
  String $sunstone_fireedge_priv_endpoint       = 'http://localhost:2616',
  String $sunstone_fireedge_pub_endpoint        = 'http://localhost:2616',
  String $sunstone_vnc_proxy_port               = '29876',
  String $sunstone_vnc_proxy_support_wss        = 'no',
  String $sunstone_vnc_proxy_cert               = '',
  String $sunstone_vnc_proxy_key                = '',
  String $sunstone_vnc_proxy_ipv6               = 'false',
  String $oneuid                                = '9869',
  String $onegid                                = '9869',
  Integer $oned_monitoring_interval             = 60,
  Integer $oned_monitoring_interval_host        = 180,
  Integer $oned_monitoring_interval_vm          = 180,
  Integer $oned_monitoring_interval_datastore   = 300,
  Integer $oned_monitoring_interval_market      = 600,
  Integer $oned_monitoring_threads              = 50,
  Integer $oned_information_collector_interval  = 20,
  String $http_proxy                            = '',
  String $hook_scripts_path                     = 'puppet:///modules/one/hookscripts',
  Array[String] $hook_scripts_pkgs              = [],
  Hash $hook_scripts                            = {},
  Array[String] $oned_inherit_datastore_attrs   = [],
  Optional[String] $oned_onegate_ip             = undef,
  Optional[String] $oned_onegate_endpoint       = undef,
  String $kickstart_network                     = $one::params::kickstart_network,
  String $kickstart_partition                   = $one::params::kickstart_partition,
  String $kickstart_rootpw                      = $one::params::kickstart_rootpw,
  Hash $kickstart_data                          = $one::params::kickstart_data,
  String $kickstart_tmpl                        = $one::params::kickstart_tmpl,
  Hash $preseed_data                            = $one::params::preseed_data,
  String $preseed_debian_mirror_url             = $one::params::preseed_debian_mirror_url,
  String $preseed_ohd_deb_repo                  = $one::params::preseed_ohd_deb_repo,
  String $preseed_tmpl                          = $one::params::preseed_tmpl,
  String $backup_script_path                    = $one::params::backup_script_path,
  String $backup_dir                            = $one::params::backup_dir,
  String $backup_opts                           = $one::params::backup_opts,
  String $backup_db                             = $one::params::backup_db,
  String $backup_db_user                        = $one::params::backup_db_user,
  String $backup_db_password                    = $one::params::backup_db_password,
  String $backup_db_host                        = $one::params::backup_db_host,
  String $backup_intervall                      = $one::params::backup_intervall,
  String $backup_keep                           = $one::params::backup_keep,
  Array $node_packages                          = $one::params::node_packages,
  Array $oned_packages                          = $one::params::oned_packages,
  String $dbus_srv                              = $one::params::dbus_srv,
  String $dbus_pkg                              = $one::params::dbus_pkg,
  Array $oned_sunstone_packages                 = $one::params::oned_sunstone_packages,
  Array $oned_sunstone_ldap_pkg                 = $one::params::oned_sunstone_ldap_pkg,
  Array $oned_oneflow_packages                  = $one::params::oned_oneflow_packages,
  Array $oned_onegate_packages                  = $one::params::oned_onegate_packages,
  Boolean $package_ensure_latest                = $one::params::package_ensure_latest,
  String $libvirtd_srv                          = $one::params::libvirtd_srv,
  String $libvirtd_cfg                          = $one::params::libvirtd_cfg,
  String $libvirtd_source                       = $one::params::libvirtd_source,
  Boolean $manage_sudoer_config                 = true,
  Stdlib::Absolutepath $oneadmin_sudoers_file   = $one::params::oneadmin_sudoers_file,
  Stdlib::Absolutepath $imaginator_sudoers_file = $one::params::imaginator_sudoers_file,
  String $oned_vlan_ids_start                   = '2',
  String $oned_vlan_ids_reserved                = '0, 1, 4095',
  String $oned_vxlan_ids_start                  = '2',
  Optional[String[1]] $kvm_driver_emulator      = undef,
  Optional[String[1]] $kvm_driver_nic_attrs     = undef,
  Array[String] $rubygems                       = $one::params::rubygems,
  Integer $sched_interval                       = 30,
  Integer $sched_max_vm                         = 5000,
  Integer $sched_max_dispatch                   = 30,
  Integer $sched_max_host                       = 1,
  Integer $sched_live_rescheds                  = 0,
  Integer $sched_default_policy                 = 1,
  String $sched_default_rank                    = '- (RUNNING_VMS * 50  + FREE_CPU)',
  Integer $sched_default_ds_policy              = 1,
  String $sched_default_ds_rank                 = '',
  String $sched_log_system                      = 'file',
  Integer $sched_log_debug_level                = 3,
  String $datastore_capacity_check              = 'yes',
  String $default_image_type                    = 'OS',
  String $default_device_prefix                 = 'hd',
  String $default_cdrom_device_prefix           = 'hd',
  String $one_version                           = '4.12',
) inherits one::params {
  # Data Validation

  # fireedge is only available with ONE >=6
  if ($sunstone_fireedge and versioncmp($one_version, '6.0') < 0) {
    fail('Fireedge is only available as of OpenNebula 6')
  }

  # the priv key is mandatory on the head.
  if ($ssh_pub_key == undef) {
    fail('The ssh_pub_key is mandatory for all nodes')
  }

  if ( $workernode == false ) {
    if ($ssh_priv_key_param != '') {
      fail('The ssh_priv_key_param is mandatory for the head')
    }
    $ssh_priv_key = $ssh_priv_key_param
  }

  if ($hook_scripts) {
    $vm_hook_scripts = $hook_scripts['VM'] # lint:ignore:variable_contains_upcase

    if ($vm_hook_scripts) {
      validate_hash($vm_hook_scripts)
    }

    $host_hook_scripts = $hook_scripts['HOST'] # lint:ignore:variable_contains_upcase
    if ($host_hook_scripts) {
      validate_hash($host_hook_scripts)
    }
  }

  # I'd use member() here but the stdlib version we're currently using doesn't know that,
  # so feel free to change once the stlib was updated to a more recent version
  if (($oned_log_system != 'file') and ($oned_log_system != 'syslog')) {
    fail("\"${oned_log_system}\" is not a valid logging subsystem. Valid values are [\"file\", \"syslog\"].")
  }

  # check if version greater than or equal to 4.14 (used in templates)
  if ( versioncmp($one_version, '4.14') >= 0 ) {
    $version_gte_4_14 = true
  }
  else {
    $version_gte_4_14 = false
  }

  # check if version greater than or equal to 5.0 (used in templates)
  if ( versioncmp($one_version, '5.0') >= 0 ) {
    $version_gte_5_0 = true
  }
  else {
    $version_gte_5_0 = false
  }

  # check if version greater than or equal to 5.8 (used in templates)
  if ( versioncmp($one_version, '5.8') >= 0 ) {
    $version_gte_5_8 = true
  }
  else {
    $version_gte_5_8 = false
  }

  # for some things we only need X.Y not X.Y.Z so trim off any extra points
  $one_version_array = split($one_version,'[.]')
  $one_version_short = "${one_version_array[0]}.${one_version_array[1]}"

  # build template version string (to be used to select templates)
  # keys are the one_version_short for which we have templates
  # values are the folder paths to use
  $templated_versions_mapping = {
    '5.0'  => '5.0',
    '5.2'  => '5.2',
    '5.4'  => '5.4',
    '5.8'  => '5.8',
    '5.12' => '5.12',
    '6.2'  => '6.2',
    '6.4'  => '6.4',
    '6.6'  => '6.6',
  }

  if member(keys($templated_versions_mapping), $one_version_short) {
    $template_path = $templated_versions_mapping[$one_version_short]
  }
  else {
    if $version_gte_5_0 {
      fail("One_version ${one_version} not in templated_versions_mapping. Compare templates for this new version and add to puppet module.")
    }
    else {
      $template_path = 'unversioned'
    }
  }

  if ( ! empty($oned_onegate_endpoint) ) {
    if ( ! empty($oned_onegate_ip) ) {
      fail("You can't provide both oned_onegate_ip and oned_onegate_endpoint as parameter.")
    }
  }

  # package version parsing
  if ($package_ensure_latest) {
    if ($ha_setup) {
      warning('using $::one::package_ensure_latest = true with ha_setup = true is risky - can lead to oned service stopping if rpm updated')
    }
    $package_ensure = 'latest'
  } else {
    $package_ensure = 'present'
  }

  contain one::prerequisites
  contain one::install
  contain one::config
  contain one::service

  Class['one::prerequisites'] ->
  Class['one::install'] ->
  Class['one::config'] ->
  Class['one::service']

  if ($oned) {
    if ( member(['kvm','xen','vmware','ec2', 'ganglia','dummy'], $im_mad) ) {
      if ( member(['kvm','xen','vmware','ec2', 'qemu', 'dummy'], $vm_mad) ) {
        if ( member(['802.1Q','ebtables','firewall','ovswitch','vmware','dummy'], $vn_mad) ) {
          contain one::oned
        } else {
          fail("Network Type: ${vn_mad} is not supported.")
        }
      } else {
        fail("Virtualization type: ${vm_mad} is not supported")
      }
    } else {
      fail("Information Manager type: ${im_mad} is not supported")
    }
  }
  if ($workernode) {
    contain one::compute_node
  }
  if ($sunstone) {
    contain one::oned::sunstone
  }
  if($oneflow) {
    contain one::oned::oneflow
  }
  if($onegate) {
    contain one::oned::onegate
  }
}
