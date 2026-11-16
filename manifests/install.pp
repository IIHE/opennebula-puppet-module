# Class one::install
#
# packages needed by both (compute node and head)
#
# === Parameters
#
# $http_proxy:: HTTP proxy used by RubyGems when installing gems.
# $dbus_pkg:: Name of the D-Bus package.
# $package_ensure:: Default package ensure value (`latest` or `present`).
#
class one::install (
  Optional[String[1]] $http_proxy = $one::http_proxy,
  String $dbus_pkg                = $one::dbus_pkg,
  String $package_ensure          = $one::package_ensure,
) inherits one {
  File['/etc/gemrc'] -> Package <| provider == 'gem' |>

  file { '/etc/gemrc':
    ensure  => file,
    content => "---\nhttp_proxy: ${http_proxy}\n",
  }

  -> package { $dbus_pkg:
    ensure  => $package_ensure,
  }
}
