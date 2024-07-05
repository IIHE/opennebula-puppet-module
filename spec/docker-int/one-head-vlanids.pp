# head with vlanids and vxlanids for docker testing
class { 'one':
  oned                   => true,
  workernode             => false,
  sunstone               => true,
  one_version            => $one_version,
  oned_vlan_ids_start    => 10,
  oned_vlan_ids_reserved => '400, 410',
  oned_vxlan_ids_start   => '12',
  package_ensure_latest  => false,
}
