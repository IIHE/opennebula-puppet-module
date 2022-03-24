# to configure libvirt so that it can use a ceph rbd pool
# source: https://github.com/openstack/puppet-nova/blob/master/manifests/compute/rbd.pp
class one::compute_node::libvirt_with_ceph (
  $libvirt_rbd_secret_uuid = hiera('one::compute_node::libvirt_rbd_secret_uuid', undef),
  $libvirt_rbd_secret_key  = hiera('one::compute_node::libvirt_rbd_secret_key', undef),
) {

  if ( ($libvirt_rbd_secret_uuid != undef) and ($libvirt_rbd_secret_key != undef) ) {

    $secret_dir = '/etc/libvirt/ceph';
    $secret_xml_path = "${secret_dir}/secret.xml";
    $virsh_secret_path = "${secret_dir}/virsh.secret";
    file { $secret_dir:
      ensure => directory,
      mode   => '0640',
      owner  => 'root',
      group  => 'root',
    }
    file { $secret_xml_path:
      content => template('secret.xml.erb'),
      mode   => '0640',
      owner  => 'root',
      group  => 'root',
      require => File[$secret_dir],
    }
    file { $virsh_secret_path:
      mode   => '0640',
      owner  => 'root',
      group  => 'root',
      require => File[$secret_dir],
    }

    # define the virsh secret
    $cm = "/usr/bin/virsh secret-define --file $secret_xml_path | /usr/bin/awk \'{print $2}\' | sed \'/^$/d\' > $virsh_secret_path"
    exec { 'get-or-set virsh secret':
      command => $cm,
      unless  => "/usr/bin/virsh secret-list | grep -i ${libvirt_rbd_secret_uuid}",
      require => File[$secret_xml_path],
    }

    # set the value of virsh secret
    exec { 'set-secret-value virsh':
      command => "/usr/bin/virsh secret-set-value --secret ${libvirt_rbd_secret_uuid} --base64 ${libvirt_rbd_secret_key}",
      unless  => "/usr/bin/virsh secret-get-value ${libvirt_rbd_secret_uuid} | grep ${libvirt_rbd_secret_key}",
      require => Exec['get-or-set virsh secret'],
    }

  } else {

    fail('When configuring libvirt for ceph, you must define the rbd secret uuid and key.')
  }

}
