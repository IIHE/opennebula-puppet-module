# == Class one::oned::sunstone::service
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
#
# === License
# Apache License Version 2.0
# http://www.apache.org/licenses/LICENSE-2.0.html
#
class one::oned::sunstone::service (
  Boolean $sunstone_passenger = $one::sunstone_passenger,
  Boolean $sunstone_novnc     = $one::sunstone_novnc,
  Boolean $sunstone_fireedge  = $one::sunstone_fireedge,
) {
  if $sunstone_passenger {
    $srv_ensure = stopped
    $srv_enable = false
  } else {
    $srv_ensure = running
    $srv_enable = true
  }
  $_sunstone_novnc_ensure = $sunstone_novnc ? {
    true    => running,
    default => stopped,
  }
  service { 'opennebula-sunstone':
    ensure  => $srv_ensure,
    enable  => $srv_enable,
    require => Service['opennebula'],
  }
  service { 'opennebula-novnc':
    ensure => $_sunstone_novnc_ensure,
    enable => $sunstone_novnc,
  }
  if $sunstone_fireedge {
    service { 'opennebula-fireedge':
      ensure => running,
      enable => true,
    }
  }
}
