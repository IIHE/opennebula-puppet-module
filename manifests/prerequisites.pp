#
# == Class one::prerequisites
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
# - Thomas Fricke (Endocode AG)
# - Stephane Gerard (Vrije Universiteit Brussel)
#
# === License
# Apache License Version 2.0
# http://www.apache.org/licenses/LICENSE-2.0.html
#
class one::prerequisites (
  Boolean $one_repo_enable  = $one::repo_enable,
) {
  case $facts['os']['family'] {
    'RedHat': {
      $repourl = "http://downloads.opennebula.org/repo/${one::one_version_short}/RedHat/${facts['os']['release']['major']}/x86_64/"
      if ( $one_repo_enable ) {
        yumrepo { 'opennebula':
          baseurl  => $repourl,
          descr    => 'OpenNebula',
          enabled  => 1,
          gpgcheck => 0,
        }
      }
      notice("We use repo ${repourl} for opennebula.")
    }
    'Debian' : {
      if ( $one_repo_enable ) {
        include apt
        case $facts['os']['name'] {
          'Debian': {
            $apt_location = "${one::one_version_short}/Debian/${facts['os']['release']['major']}"
            $apt_pin = '-10'
          }
          'Ubuntu': {
            $apt_location = "${one::one_version_short}/Ubuntu/${facts['os']['release']['major']}"
            $apt_pin = '500'
          }
          default: { fail("Unrecognized operating system ${facts['os']['name']}") }
        }

        apt::key { 'one_repo_key':
          key        => '85E16EBF',
          key_source => 'http://downloads.opennebula.org/repo/Debian/repo.key',
        }

        -> apt::source { 'one-official': # lint:ignore:security_apt_no_key
          location          => "http://downloads.opennebula.org/repo/${apt_location}",
          release           => 'stable',
          repos             => 'opennebula',
          required_packages => 'debian-keyring debian-archive-keyring',
          pin               => $apt_pin,
          include_src       => false,
        }
      }
    }
    default: {
      notice('We use opennebula from default OS repositories.')
    }
  }
  group { 'oneadmin':
    ensure => present,
    gid    => $one::onegid,
  }
  -> user { 'oneadmin':
    ensure     => present,
    uid        => $one::oneuid,
    gid        => $one::onegid,
    home       => '/var/lib/one',
    managehome => true,
    shell      => '/bin/bash',
  }
}
