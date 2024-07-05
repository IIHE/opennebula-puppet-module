# == Class one::oned::sunstone::ldap
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
class one::oned::sunstone::ldap (
  Array[String] $oned_sunstone_ldap_pkg = $one::oned_sunstone_ldap_pkg,
  Hash $ldap_mappings              = $one::ldap_mappings,
  String $ldap_mapping_filename    = $one::ldap_mapping_filename,
  String $package_ensure                = $one::package_ensure,
) inherits one {
  package { $oned_sunstone_ldap_pkg:
    ensure => $package_ensure,
  }
  -> file { '/var/lib/one/remotes/auth/default':
    ensure => link,
    owner  => 'oneadmin',
    group  => 'oneadmin',
    target => '/var/lib/one/remotes/auth/ldap',
  }
  -> file { '/etc/one/auth/ldap_auth.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'oneadmin',
    mode    => '0640',
    content => template('one/ldap_auth.conf.erb'),
    notify  => Service['opennebula'],
  }
  if $ldap_mappings != undef {
    validate_hash($ldap_mappings)
    file { "/var/lib/one/${ldap_mapping_filename}":
      ensure  => file,
      owner   => 'oneadmin',
      group   => 'oneadmin',
      mode    => '0644',
      content => template('one/ldap_mappings.yaml.erb'),
    }
  }
}
