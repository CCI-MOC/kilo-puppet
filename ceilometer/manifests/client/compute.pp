#
# Installs the ceilometer python library.
#
# == parameters
#  [*ensure*]
#    ensure state for pachage.
#
class ceilometer::client::compute (
  $ensure = 'present'
) {

  include ::ceilometer::params

  package { 'python-ceilometerclient':
    ensure => $ensure
  }

  package { 'python-pecan':
    ensure => $ensure
  }
 
  class { 'ceilometer::db' : 
    database_connection => $quickstack::params::ceilometer_db
  }

  class { 'ceilometer::agent::auth':
     auth_url => $quickstack::params::ceilometer_auth_uri,
     auth_password => $quickstack::params::ceilometer_password
  }

  class { 'ceilometer::api':
    keystone_auth_uri => $quickstack::params::ceilometer_auth_uri,
    keystone_identity_uri => $quickstack::params::ceilometer_identity_uri,
    keystone_password     => $quickstack::params::ceilometer_password
  }
}

