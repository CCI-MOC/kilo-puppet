class ssh::server::config_admin_user (
  $user            = $quickstack::params::moc_admin_user,
  $password        = $quickstack::params::moc_admin_password,
  $hashed_password = $quickstack::params::moc_admin_hashed_password,
  $authorized_keys = 'authorized_keys',
) inherits quickstack::params {
  case $::osfamily {
    redhat: {
      user { $user:
        ensure     => 'present',
        home       => "/home/${user}",
        groups     => 'wheel',
        password   => $hashed_password,
        managehome => true,
      } ->
      file { "/home/${user}/.ssh":
        ensure => directory,
        owner => $user,
        group => $user,
        mode => '0700',
      } ->
      file { "/home/${user}/.ssh/authorized_keys":
        ensure  => present,
        owner   => $user,
        group   => $user,
        mode    => '0600',
        replace => true,
        source  => "puppet:///modules/${module_name}/${authorized_keys}",
        require => Class['ssh::server::install']
      } ->
      file {"/home/${user}/access.txt":
        ensure  => present,
	owner   => $user,
	group   => $user,
	mode    => '0400',
	replace => true,
      } ->
      exec {"store-passwd":
        command => "/bin/echo ${password} > /home/${user}/access.txt",
      }
    }
    default: {
        fail("Unsupported platform: ${::osfamily}/${::operatingsystem}")
    }
  }
}
