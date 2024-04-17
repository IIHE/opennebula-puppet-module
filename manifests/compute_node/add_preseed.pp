#
# Define one::compute_node::add_preseed
#
# configure Debian preseed file
#
define one::compute_node::add_preseed (
  String $preseed_tmpl      = 'one/preseed.cfg.erb',
  String $debian_mirror_url = $one::compute_node::config::debian_mirror_url,
  Hash $data                = {}
) {
  file { "/var/lib/one/etc/preseed.d/${name}.cfg":
    ensure  => file,
    owner   => 'oneadmin',
    group   => 'oneadmin',
    content => template($preseed_tmpl),
  }
}
