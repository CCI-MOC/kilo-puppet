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

  package { 'openstack-ceilometer-api':
    ensure => $ensure,
  }

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

}

