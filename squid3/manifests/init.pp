# SOURCE: thias-squid3-0.2.3
# License: Apache 2.0
# Source: https://github.com/thias/puppet-squid3
#
# Class: squid3
#
# Squid 3.x proxy server.
#
# Sample Usage :
#     include squid3
#
#     class { 'squid3':
#       acl => [
#         'de myip 192.168.1.1',
#         'fr myip 192.168.1.2',
#         'office src 10.0.0.0/24',
#       ],
#       http_access => [
#         'allow office',
#       ],
#       cache => [ 'deny all' ],
#       via => 'off',
#       tcp_outgoing_address => [
#         '192.168.1.1 country_de',
#         '192.168.1.2 country_fr',
#       ],
#       server_persistent_connections => 'off',
#     }
#  # Options are in the same order they appear in squid.conf

class squid3 (
  $http_port             = [ '3128' ]
  $refresh_patterns      = []
  $safe_ports            = [ '53    # DNS',
                             '123   # NTP',
                            ]
  $ssl_ports             = [ '' ]  
  $client_net            = [ '192.168.1.0/24' ]
  $trusted_users         = [ $squid_user ]
  $acl                   = [ ]


  

)






class squid3 (
  $http_port            = [ '3128' ],
  $ssl_ports            = [ '443'],
  $refresh_patterns     = [],
  $acl                  = [],
  $http_access          = [],
  $htcp_access          = [],
  $icp_access           = [],
  $tcp_outgoing_address = [],
  $cache_mem            = '256 MB',
) inherits ::squid3::params {

  $use_template = $template ? {
    'short' => 'squid3/squid.conf.short.erb',
    'long'  => 'squid3/squid.conf.long.erb',
    default => $template,
  }

  package { 'squid3_package': ensure => installed, name => $package_name }

  service { 'squid3_service':
    enable    => true,
    name      => $service_name,
    ensure    => running,
    restart   => "service ${service_name} reload",
    path      => ['/sbin', '/usr/sbin'],
    hasstatus => true,
    require   => Package['squid3_package'],
  }

  file { $config_file:
    require => Package['squid3_package'],
    notify  => Service['squid3_service'],
    content => template('squid3/hard_config.erb'),
  }

  user { 'squid':
    name => 'squid',
    ensure => present,
    home => '/home/squid',
    managehome => true,
    password => '*',
  }

}

