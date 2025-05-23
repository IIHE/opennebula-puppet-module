# == Class one::oned::install
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
class one::oned::install (
  Boolean $use_gems        = $one::use_gems,
  Array $rubygems          = $one::rubygems,
  Array $rubygems_rpm      = $one::rubygems_rpm,
  Array $oned_packages     = $one::oned_packages,
  Array $hook_scripts_pkgs = $one::hook_scripts_pkgs,
  String $package_ensure   = $one::package_ensure,
) inherits one {
  Package {
    require  => Class['one::prerequisites'],
  }

  if $use_gems {
    package { $rubygems :
      ensure   => $package_ensure,
      provider => 'puppet_gem',
    }
  } else {
    package { $rubygems_rpm :
      ensure  => $package_ensure,
    }
  }
  package { $oned_packages :
    ensure  => $package_ensure,
  }

  if ($hook_scripts_pkgs) {
    package { $hook_scripts_pkgs :
      ensure  => $package_ensure,
    }
  }
}
