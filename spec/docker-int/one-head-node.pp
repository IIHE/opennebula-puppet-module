# head with node, oned and sunstone for docker testing
class { 'one':
  oned        => true,
  node        => true,
  sunstone    => true,
  one_version => $one_version,
}
