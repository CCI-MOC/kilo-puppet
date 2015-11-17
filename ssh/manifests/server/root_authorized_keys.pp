class ssh::server::root_authorized_keys {
  case $::osfamily {
    redhat: {
      file { '/root/.ssh':
        ensure => directory,
        owner => 'root',
        group => 'root',
        mode => '0700',
      } ->
      file { $ssh::params::root_authorized_keys:
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
        replace => true,
        source  => "puppet:///modules/${module_name}/root_authorized_keys",
        require => Class['ssh::server::install']
      }
    }
    default: {
        fail("Unsupported platform: ${::osfamily}/${::operatingsystem}")
    }
  }
}
