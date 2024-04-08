# example of a one pure worker-node for docker testing
class { 'one':
  oned        => false,
  node        => true,
  one_version => $one_version,
}
