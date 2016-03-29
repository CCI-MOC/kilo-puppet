#
# Installs the ceilometer python library.
#
# == parameters
#  [*ensure*]
#    ensure state for pachage.
#
class ceilometer::client (
  $ensure = 'present'
) {

  include ::ceilometer::params


#  $enhancers = $::ceilometer::params::client_package_names
  #$enhancers = ['openstack-ceilometer-compute', 'python-ceilometerclient', 'python-pecan']

#  package { 'openstack-ceilometer-compute':
#    ensure => $ensure,
#    provider => 'rpm',
#    tag    => 'openstack',
#  }

  package { 'python-ceilometerclient':
    ensure => $ensure,
#    provider => 'rpm',
#    tag    => 'openstack',
  }

  package { 'python-pecan':
    ensure => $ensure,
#    provider => 'rpm',
#    tag    => 'openstack',
  }

}

