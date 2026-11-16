# example of a head with only oned and sunstone for docker testing
class { 'one':
  oned                  => true,
  workernode            => false,
  sunstone              => true,
  one_version           => '7.4',
  package_ensure_latest => false,
}
