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
    default: {
      fail("Your OS - ${facts['os']['family']} - is not yet supported.")
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
