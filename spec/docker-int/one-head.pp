# example of a head with only oned and sunstone for docker testing
class { 'one':
  oned                  => true,
  node                  => false,
  sunstone              => true,
  one_version           => $one_version,
  package_ensure_latest => false,
}
