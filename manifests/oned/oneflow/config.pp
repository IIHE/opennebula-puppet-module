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
# === Parameters
#
# $oneflow_one_xmlrpc:: OpenNebula XML-RPC endpoint used by OneFlow.
# $oneflow_lcm_interval:: Lifecycle manager interval in seconds.
# $oneflow_host:: Address on which the OneFlow server listens.
# $oneflow_port:: TCP port used by the OneFlow server.
# $oneflow_default_cooldown:: Default cooldown between lifecycle actions.
# $oneflow_shutdown_action:: Default action used to shut down services.
# $oneflow_action_number:: Number of lifecycle actions performed per period.
# $oneflow_action_period:: Period used to throttle lifecycle actions.
# $oneflow_vm_name_template:: Template used to name service virtual machines.
# $oneflow_core_auth:: Authentication method used by OneFlow core.
# $oneflow_debug_level:: OneFlow debug level.
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
