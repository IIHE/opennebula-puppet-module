# == Class one::oned::sunstone::install
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
class one::oned::sunstone::install (
  Array $oned_sunstone_packages = $one::oned_sunstone_packages,
  String $package_ensure        = $one::package_ensure,
  Boolean $sunstone_fireedge    = $one::sunstone_fireedge,
  String $one_version           = $one::one_version,
) inherits one {
  package { $oned_sunstone_packages:
    ensure => $package_ensure,
  }
  if (versioncmp($one_version, '6') >= 0 and $sunstone_fireedge) {
    case $facts['os']['name'] {
      'CentOS': {
        if ($facts['os']['release']['major'] == '7') {
          package { 'centos-release-scl-rh':
            ensure => $package_ensure,
          }
        }
        package { ['opennebula-fireedge', 'opennebula-guacd']:
          ensure => $package_ensure,
        }
      }
      default: {
        fail("Your OS - ${facts['os']['name']} - is not yet supported.")
      }
    }
  }
}
