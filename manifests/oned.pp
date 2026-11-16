# == Class one::oned
#
# Installs and configures OpenNebula management node
#
# === Author
# ePost Development GmbH
# (c) 2013
#
# Contributors:
# - Martin Alfke
# - Achim Ledermueller (Netways GmbH)
# - Sebastian Saemann (Netways GmbH)
# - Stephane Gerard (Vrije Universiteit Brussel)
#
# === Parameters
#
# $backend:: Database backend (`sqlite` or `mysql`).
# $ldap:: Whether to enable LDAP authentication in Sunstone.
# $puppetdb:: Whether to use PuppetDB to discover compute nodes.
# $oneid:: Identifier of the OpenNebula cloud.
#
# === Usage
#
# Do not use this class directly. Use class one instead.
# See documentation in one/manifests/init.pp
#
# === License
# Apache License Version 2.0
# http://www.apache.org/licenses/LICENSE-2.0.html
#
class one::oned (
  String $backend   = $one::backend,
  Boolean $ldap     = $one::ldap,
  Boolean $puppetdb = $one::puppetdb,
  String $oneid     = $one::oneid,
) {
  include one::prerequisites
  include one::install
  include one::service
  include one::config
  include one::oned::install
  include one::oned::config
  include one::oned::service

  Class['one::prerequisites']
  -> Class['one::install']
  -> Class['one::config']
  -> Class['one::oned::install']
  -> Class['one::oned::config']
  ~> Class['one::oned::service']
  ~> Class['one::service']

  # lint:ignore:strict_indent
  if ( $backend != 'mysql' and $backend != 'sqlite') {
    fail ( "Class one::oned need to get called with proper DB backend
      (sqlite or mysql). ${backend} is not supported.")
  }
  if ( $ldap != true and $ldap != false) {
      fail( "Class one::oned need to get called with proper ldap value
        (true or false). ${ldap} is not supported.")
  }
  # lint:endignore

  if $puppetdb {
    # Realize all the known nodes
    Onehost <<| tag == $oneid |>> {
      require => Class[one::oned::service],
    }
  }
}
