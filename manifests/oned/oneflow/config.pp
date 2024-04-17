#
# == Class one::oned::oneflow::config
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
class one::oned::oneflow::config (
  String $oneflow_one_xmlrpc                                   = $one::oneflow_one_xmlrpc,
  Integer $oneflow_lcm_interval                                = $one::oneflow_lcm_interval,
  Stdlib::IP::Address::V4 $oneflow_host                        = $one::oneflow_host,
  Integer $oneflow_port                                        = $one::oneflow_port,
  Integer $oneflow_default_cooldown                            = $one::oneflow_default_cooldown,
  Enum['terminate', 'terminate-hard'] $oneflow_shutdown_action = $one::oneflow_shutdown_action,
  Integer $oneflow_action_number                               = $one::oneflow_action_number,
  Integer $oneflow_action_period                               = $one::oneflow_action_period,
  String $oneflow_vm_name_template                             = $one::oneflow_vm_name_template,
  Enum['cipher', 'x509'] $oneflow_core_auth                    = $one::oneflow_core_auth,
  Integer $oneflow_debug_level                                 = $one::oneflow_debug_level,
) {
  file { '/etc/one/oneflow-server.conf':
    ensure  => file,
    mode    => '0640',
    owner   => 'root',
    group   => 'oneadmin',
    content => template('one/oneflow-server.conf.erb'),
  }
}
