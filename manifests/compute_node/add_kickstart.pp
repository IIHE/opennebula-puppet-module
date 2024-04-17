#
# Define one::compute_node::add_kickstart
#
# defines the kickstart.ks file
#
define one::compute_node::add_kickstart (
  String $kickstart_tmpl = 'one/kickstart.ks.erb',
  String $networkconfig  = $one::compute_node::config::networkconfig,
  String $partitions     = $one::compute_node::config::partitions,
  Hash $data             = {}
) {
  file { "/var/lib/one/etc/kickstart.d/${name}.ks":
    ensure  => file,
    owner   => 'oneadmin',
    group   => 'oneadmin',
    content => template($kickstart_tmpl),
  }
}
