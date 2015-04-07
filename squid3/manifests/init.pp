# BASED ON: thias-squid3-0.2.3
# Source: https://github.com/thias/puppet-squid3
# License: Apache 2.0
# Source: -> insert source here <-
#
# Class: squid3
#
# Squid 3.x hardened
#
# Sample Usage :
#     include squid3
#
#     class { 'squid3':
#		http_port => [	
#						'3128',
#						'8080'
#					 ]
#		safe_ports => [
#						'70			   	# Gopher',
#					  ],
#		tls_ports	=> [
#					   	'22				# SSH',
#					   ],					  
#       acl => [
#         'localnet src 10.0.0.0/8     # RFC 1918 possible internal network',
#		  'localnet src 172.16.0.0/12  # RFC 1918 possible internal network',	
#         'localnet src 192.168.0.0/16 # RFC 1918 possible internal network',
#		  'localnet src fc00::/7       # RFC 4193 local private network range',
#       ],
#       http_access => [
#         'allow localnet',
#       ],
#       server_persistent_connections => 'off',
#     }
# 
class squid3 (
  $http_port             = [ '3128' ],
  $refresh_patterns      = [],
  $safe_ports            = [ '53    # DNS',
                             '123   # NTP',
                            ],
  $tls_ports             = [],
  $trusted_users         = 'root'
  $acl                   = [ ],
  $http_access           = [],
  $squid_user            = 'squid',
  $squid_group           = 'squid',

  $client_lifetime            = '1 day',
  $pconn_timeout              = '1 minute',
  $request_header_max_size    = '64 KB',
  $maximum_object_size        = '4 MB',
  $minimum_object_size        = '2 KB',
  $authenticate_ttl           = '1 hour',
  $authenticate_ip_ttl        = '0 seconds',
  $server_persistent_connections = 'off',
  $forwarded_for              = 'off',
  $ignore_unknown_nameservers = 'on',
  $icp_port                   = '0',
  $htcp_port                  = '0',
)inherits ::squid3::params {
  
  package { 'squid3_package':
    ensure => installed,
    name => $package_name, 
  }

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
    home => '/var/squid',
    managehome => true,
    password => '*',
  }

}

