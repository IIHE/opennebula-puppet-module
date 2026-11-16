# == Class one::oned::sunstone::config
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
# $listen_ip:: Address on which Sunstone or FireEdge listens.
# $enable_support:: Whether the support tab is enabled in Sunstone.
# $enable_marketplace:: Whether the marketplace tab is enabled in Sunstone.
# $tmpdir:: Temporary directory used by Sunstone.
# $vnc_proxy_port:: Port used by the Sunstone VNC proxy.
# $vnc_proxy_support_wss:: Whether the VNC proxy supports secure WebSockets.
# $vnc_proxy_cert:: Path to the VNC proxy certificate.
# $vnc_proxy_key:: Path to the VNC proxy private key.
# $vnc_proxy_ipv6:: Whether the VNC proxy supports IPv6.
# $sunstone_logo_png:: Source of a custom Sunstone login logo.
# $sunstone_logo_small_png:: Source of a custom small Sunstone logo.
# $fireedge:: Whether FireEdge is enabled.
# $fireedge_private_endpoint:: Private FireEdge endpoint URL.
# $fireedge_public_endpoint:: Public FireEdge endpoint URL.
# $one_version:: OpenNebula version used to select the configuration template.
#
# === License
# Apache License Version 2.0
# http://www.apache.org/licenses/LICENSE-2.0.html
#
class one::oned::sunstone::config (
  String $listen_ip                            = $one::sunstone_listen_ip,
  String $enable_support                       = $one::sunstone_enable_support,
  String $enable_marketplace                   = $one::sunstone_enable_marketplace,
  String $tmpdir                               = $one::sunstone_tmpdir,
  String $vnc_proxy_port                       = $one::sunstone_vnc_proxy_port,
  String $vnc_proxy_support_wss                = $one::sunstone_vnc_proxy_support_wss,
  Optional[String[1]] $vnc_proxy_cert          = $one::sunstone_vnc_proxy_cert,
  Optional[String[1]] $vnc_proxy_key           = $one::sunstone_vnc_proxy_key,
  String $vnc_proxy_ipv6                       = $one::sunstone_vnc_proxy_ipv6,
  Optional[String[1]] $sunstone_logo_png       = $one::sunstone_logo_png,
  Optional[String[1]] $sunstone_logo_small_png = $one::sunstone_logo_small_png,
  Boolean $fireedge                            = $one::sunstone_fireedge,
  String $fireedge_private_endpoint            = $one::sunstone_fireedge_priv_endpoint,
  String $fireedge_public_endpoint             = $one::sunstone_fireedge_pub_endpoint,
  String $one_version                          = $one::one_version,
) inherits one {
  $sunstone_views_root = '/etc/one/sunstone-views/mixed'

  File {
    owner   => 'root',
    group   => 'oneadmin',
  }

  if (versioncmp($one_version, '7') < 0) {
    file { '/etc/one/sunstone-server.conf':
      ensure  => file,
      content => template("one/${one::template_path}/sunstone-server.conf.erb"),
      notify  => Service['opennebula-sunstone'],
    }
    -> file { '/etc/one/sunstone-views.yaml':
      ensure  => file,
      mode    => '0640',
      content => template("one/${one::template_path}/sunstone-views.yaml.erb"),
    }
    -> file { "${sunstone_views_root}/admin.yaml":
      ensure  => file,
      mode    => '0640',
      content => template("one/${one::template_path}/sunstone-views-admin.yaml.erb"),
    }
    -> file { "${sunstone_views_root}/user.yaml":
      ensure  => file,
      mode    => '0640',
      content => template("one/${one::template_path}/sunstone-views-user.yaml.erb"),
    }

    file { "${sunstone_views_root}/cloud.yaml":
      ensure  => file,
      mode    => '0640',
      content => template("one/${one::template_path}/sunstone-views-cloud.yaml.erb"),
      require => File["${sunstone_views_root}/user.yaml"],
    }

    if defined('$sunstone_logo_png') or defined('$sunstone_logo_small_png') {
      file { '/usr/lib/one/sunstone/public/images':
        ensure => directory,
        mode   => '0755',
      }
    }

    if defined('$sunstone_logo_png') {
      file { '/usr/lib/one/sunstone/public/images/custom_logo.png':
        ensure  => file,
        mode    => '0644',
        source  => $sunstone_logo_png,
        require => File['/usr/lib/one/sunstone/public/images'],
      }
    }

    if defined('$sunstone_logo_small_png') {
      file { '/usr/lib/one/sunstone/public/images/custom_logo_small.png':
        ensure  => file,
        mode    => '0644',
        source  => $sunstone_logo_small_png,
        require => File['/usr/lib/one/sunstone/public/images'],
      }
    }
  } else {
    file { '/etc/one/fireedge-server.conf':
      ensure  => file,
      content => template("one/${one::template_path}/fireedge-server.conf.erb"),
      notify  => Service['opennebula-fireedge'],
    }
  }
}
