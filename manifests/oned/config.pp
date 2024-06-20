# == Class one::oned::config
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
#
# === License
# Apache License Version 2.0
# http://www.apache.org/licenses/LICENSE-2.0.html
#
class one::oned::config (
  String $hook_scripts_path              = $one::hook_scripts_path,
  Hash $hook_scripts                     = $one::hook_scripts,
  # Hash $vm_hook_scripts                = $one::vm_hook_scripts,
  # Hash $host_hook_scripts              = $one::host_hook_scripts,
  Array[String] $inherit_datastore_attrs = $one::oned_inherit_datastore_attrs,
  String $oned_port                      = $one::oned_port,
  String $oned_db                        = $one::oned_db,
  String $oned_db_user                   = $one::oned_db_user,
  String $oned_db_password               = $one::oned_db_password,
  String $oned_db_host                   = $one::oned_db_host,
  String $oned_vm_submit_on_hold         = $one::oned_vm_submit_on_hold,
  String $backup_script_path             = $one::backup_script_path,
  String $backup_opts                    = $one::backup_opts,
  String $backup_dir                     = $one::backup_dir,
  String $backup_db                      = $one::backup_db,
  String $backup_db_user                 = $one::backup_db_user,
  String $backup_db_password             = $one::backup_db_password,
  String $backup_db_host                 = $one::backup_db_host,
  String $backup_intervall               = $one::backup_intervall,
  String $backup_keep                    = $one::backup_keep,
  String $debug_level                    = $one::debug_level,
  String $backend                        = $one::backend,
  Integer $sched_interval                = $one::sched_interval,
  Integer $sched_max_vm                  = $one::sched_max_vm,
  Integer $sched_max_dispatch            = $one::sched_max_dispatch,
  Integer $sched_max_host                = $one::sched_max_host,
  Integer $sched_live_rescheds           = $one::sched_live_rescheds,
  Integer $sched_default_policy          = $one::sched_default_policy,
  String $sched_default_rank             = $one::sched_default_rank,
  Integer $sched_default_ds_policy       = $one::sched_default_ds_policy,
  String $sched_default_ds_rank          = $one::sched_default_ds_rank,
  String $sched_log_system               = $one::sched_log_system,
  Integer $sched_log_debug_level         = $one::sched_log_debug_level,
  String $kvm_driver_emulator            = $one::kvm_driver_emulator,
  String $kvm_driver_nic_attrs           = $one::kvm_driver_nic_attrs,
  String $datastore_capacity_check       = $one::datastore_capacity_check,
  String $default_image_type             = $one::default_image_type,
  String $default_device_prefix          = $one::default_device_prefix,
  String $default_cdrom_device_prefix    = $one::default_cdrom_device_prefix,
) {
  if ! member(['YES', 'NO'], $oned_vm_submit_on_hold) {
    fail("oned_vm_submit_on_hold must be one of 'YES' or 'NO'. Actual value: ${oned_vm_submit_on_hold}")
  }

  if ! member(['file', 'syslog'], $sched_log_system) {
    fail("sched_log_system must be one of 'file' or 'syslog'. Actual value: ${sched_log_system}")
  }

  File {
    owner  => 'oneadmin',
    group  => 'oneadmin',
  }

  file { '/etc/one/oned.conf':
    ensure  => file,
    owner   => 'root',
    mode    => '0640',
    content => template("one/${one::template_path}/oned.conf.erb"),
  }

  file { '/etc/one/sched.conf':
    ensure  => 'file',
    owner   => 'root',
    mode    => '0640',
    content => template('one/sched.conf.erb'),
  } ->

  file { '/usr/share/one':
    ensure => directory,
    mode   => '0755',
  } ->

  file { '/usr/share/one/hooks':
    ensure  => directory,
    ignore  => 'tests/*',
    mode    => '0750',
    recurse => true,
    purge   => true,
    force   => true,
    source  => $hook_scripts_path,
  }

  if $kvm_driver_emulator {
    ini_setting { 'set_kvm_driver_emulator':
      ensure  => present,
      section => '',
      path    => '/etc/one/vmm_exec/vmm_exec_kvm.conf',
      setting => 'EMULATOR',
      value   => $kvm_driver_emulator,
    }
  }

  if $kvm_driver_nic_attrs {
    ini_setting { 'set_kvm_driver_nic':
      ensure  => present,
      section => '',
      path    => '/etc/one/vmm_exec/vmm_exec_kvm.conf',
      setting => 'NIC',
      value   => $kvm_driver_nic_attrs,
    }
  }

  if ($backend == 'mysql') {
    file { $backup_dir:
      ensure => directory,
      mode   => '0700',
    } ->

    file { $backup_script_path:
      ensure  => file,
      mode    => '0700',
      content => template('one/one_db_backup.sh.erb'),
    } ->

    cron { 'one_db_backup':
      command => $backup_script_path,
      user    => $backup_db_user,
      target  => $backup_db_user,
      minute  => $backup_intervall,
    }
  }
}
