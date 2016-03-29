#
# Installs the ceilometer python library.
#
# == parameters
#  [*ensure*]
#    ensure state for pachage.
#
class ceilometer::client::controller (
  $ensure = 'present'
) {

  package { 'openstack-ceilometer-collector':
    ensure => $ensure,
  }

  package { 'openstack-ceilometer-notification':
    ensure => $ensure,
  }

  package { 'openstack-ceilometer-central':
    ensure => $ensure,
  }

  package { 'openstack-ceilometer-alarm':
    ensure => $ensure,
  }

  package { 'python-ceilometerclient':
    ensure => $ensure,
  }

  class { 'ceilometer::db' : 
    database_connection => $quickstack::params::ceilometer_db
  }

  class { 'ceilometer::api':
    keystone_auth_uri => $quickstack::params::ceilometer_auth_uri,
    keystone_identity_uri => $quickstack::params::ceilometer_identity_uri,
    keystone_password     => $quickstack::params::ceilometer_password
  }

  class { 'ceilometer::agent::auth':
    auth_url => $quickstack::params::ceilometer_auth_uri,
    auth_password => $quickstack::params::ceilometer_password
  }

}

