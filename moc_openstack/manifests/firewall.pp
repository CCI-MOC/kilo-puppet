# This requires puppetlabs openstack module
# and puppetlabs/firewall module
#
# generic wrapper for config options not exposed
# in openstack module
#
# basic port filtering because openstack doesn't belive in application
# security in a lot of ways...
class moc_openstack::firewall (
  $interface = 'enp130s0f0', # note we dont want to get in the way of Neutron iptables
  $source = undef,
)
{
  if $::environment == 'production' {
    include ::firewall
    # for a million reasons we should be collecting a list of
    # controllers and compute hosts, when we do we should iterate here
    firewall { '000 allow openstacknet':
      chain    => 'INPUT',
      iniface  => $interface,
      proto    => 'all',
      source   => $source,
      action   => 'accept',      
    }
    firewall { '099 accept related established rules':
      proto   => 'all',
      state => ['RELATED', 'ESTABLISHED'],
      action  => 'accept',
    }
    firewall { '010 accept all icmp':
      proto   => 'icmp',
      action  => 'accept',
    }
    # should execept all from ::management_stations
#    hiera('management_stations').each |$station| {
#      firewall { "100 allow management station ${station}":
#        chain    => 'INPUT',
#        iniface  => $interface,
#        source   => "${station}/32",
#        action   => 'accept',      
#      }
#    }
#    # should accept ssh from ::local_netblocks
#    hiera('local_netblocks').each |$net| {
#      firewall { "110 allow ssh local net ${net}":
#        chain    => 'INPUT',
#        iniface  => $interface,
#        proto    => 'tcp',
#        dport    => '22',
#        source   => $net,
#        action   => 'accept',      
#      }
#    }      
    firewall { '999 drop all':
      require  => Firewall['000 allow openstacknet'],
      chain    => 'INPUT',
      iniface  => $interface,
      proto    => 'all',
      action   => 'drop',
    }
  }
}
