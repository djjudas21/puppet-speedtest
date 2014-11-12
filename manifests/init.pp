# == Class: speedtest

class speedtest (
  $source,
  $webroot = '/var/www/speedtest',
  $vhost = $::fqdn,
  $firewall = false,
) {

  # Install zip file from source
  file { 'mini.zip':
    source => $source,
    path   => "${webroot}/mini.zip",
    notify => Exec['unzip'],
  }
  
  # Unzip the zip file
  exec { 'unzip':
    command     => 'unzip mini.zip',
    cwd         => $webroot,
    path        => '/usr/bin',
    refreshonly => true,
  }

  # Create the webroot
  file { $webroot:
    ensure => directory,
  }

  # Symlink the version
  file { "${webroot}/index.html":
    ensure => 'link',
    target => 'index-php.html',
  }

  # Install the dependencies
  include apache
  include apache::mod::php

  # Define the apache server
  apache::vhost { $vhost:
    docroot  => $webroot,
    priority => '25',
  }

  # Create a firewall exception
  if ($firewall) {
    firewall { '100-speedtest':
      proto  => 'tcp',
      dport  => '80',
      action => 'accept',
    }
  }
}
