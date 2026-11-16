# head with node, oned and sunstone for docker testing
class { 'one':
  oned        => true,
  workernode  => true,
  sunstone    => true,
  one_version => '7.4',
}
