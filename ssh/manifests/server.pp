class ssh::server {
  include ssh::params
  include ssh::server::install
  include ssh::server::config
  include ssh::server::service
  include ssh::server::root_authorized_keys
  include ssh::server::config_admin_user
  include ssh::hostkeys
  include ssh::knownhosts
}
