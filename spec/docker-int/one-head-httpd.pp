# head with httpd for docker container
class httpd {
  class { 'apache':
    default_vhost => false,
  }
  include apache::mod::passenger
  include apache::mod::proxy
  include apache::mod::proxy_http

  apache::vhost { 'one':
    docroot     => '/usr/lib/one/sunstone/public',
    port        => '80',
    directories => [{ path => '/usr/lib/one/sunstone/public', options => ['-MultiViews'] }],
  }
}

class { 'one':
  oned               => true,
  workernode         => false,
  sunstone           => true,
  sunstone_passenger => true,
  one_version        => $one_version,
}

-> class { 'httpd': }
