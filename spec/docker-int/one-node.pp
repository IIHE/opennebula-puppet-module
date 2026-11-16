# example of a one pure worker-node for docker testing
class { 'one':
  oned        => false,
  workernode  => true,
  one_version => '7.4',
}
