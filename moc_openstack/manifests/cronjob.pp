#####################################################################
# Name: cronjob.pp
#
# Descr:-
# This file updates the repos present on the nodes. It makes sure
# that proper repos are present on the nodes and disables others.
# It also adds yum-cron.
#
#####################################################################

class moc_openstack::cronjob (
  $base_dir  = '/etc/yum.repos.d/',
  $repo_server = '127.0.0.1',
  $randomwait = 180,
) {

  if $::environment == 'production' {
    $rhel7_file_path = "${base_dir}rhel7local-prod.repo"
    $epel_file_path = "${base_dir}epel7local-prod.repo"
    $suricata_file_path = "${base_dir}suricata7local-prod.repo"
    $rhel7_link = "http://${repo_server}/repos/rhel7local-prod.repo"
    $epel_link = "http://${repo_server}/repos/epel7local-prod.repo"
    $suricata_link = "http://${repo_server}/repos/suricata7local-prod.repo"
  } else {
    $rhel7_file_path = "${base_dir}rhel7local.repo"
    $epel_file_path = "${base_dir}epel7local.repo"
    $suricata_file_path = "${base_dir}suricata7local.repo"
    $rhel7_link = "http://${repo_server}/repos/rhel7local.repo"
    $epel_link = "http://${repo_server}/repos/epel7local.repo"
    $suricata_link = "http://${repo_server}/repos/suricata7local.repo"
  }

  # backup the original redhat.repo before puppet run
  exec {'backup_redhat_repo':
    onlyif  => "/bin/test -f /etc/yum.repos.d/redhat.repo",
    command => "/bin/cp /etc/yum.repos.d/redhat.repo /etc/yum.repos.d/redhat.repo.default",
  } ->
  exec {'disable_redhat_repos':
    onlyif  => "/bin/test -f /etc/yum.repos.d/redhat.repo",
    command => "/bin/sed -i '/enabled/c\enabled = 0 ' /etc/yum.repos.d/redhat.repo",
  } ->
  exec {'disable_epel_repos':
    onlyif  => "/bin/test -f /etc/yum.repos.d/epel.repo",
    command => "/bin/sed -i '/enabled/c\enabled = 0 ' /etc/yum.repos.d/epel.repo",
  } ->
  exec {'disable_epel_testing_repos':
    onlyif  => "/bin/test -f /etc/yum.repos.d/epel-testing.repo",
    command => "/bin/sed -i '/enabled/c\enabled = 0 ' /etc/yum.repos.d/epel-testing.repo",
  } ->
  # update repos if something has changed. -N checks if the file's
  # timestamp has changed. If yes, it downloads it. 
  exec {'update_rhel7_file':
    command => "/bin/wget -N $rhel7_link -P /etc/yum.repos.d/",
  } ->
  exec {'update_epel_file':
    command => "/bin/wget -N $epel_link -P /etc/yum.repos.d/",
  } ->
  exec {'update_suricata_file':
    command => "/bin/wget -N $suricata_link -P /etc/yum.repos.d/",
  }

  class { 'yum_cron':
    enable           => true,
    download_updates => true,
    apply_updates    => true,
    randomwait       => $randomwait,
  }

}
