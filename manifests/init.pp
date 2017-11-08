# == Class: speedtest

class speedtest (
  $download = true,
  $url = 'http://c.speedtest.net/mini/mini.zip',
  $source = undef,
  $webroot = '/var/www/speedtest',
  $vhost = $::fqdn,
  $firewall = false,
) {

  if ($download == true) {
    # Grab zip file from Speedtest
    wget::fetch { 'mini.zip':
      source      => $url,
      destination => "${webroot}/mini.zip",
      timeout     => 0,
      verbose     => false,
      notify      => Exec['unzip'],
      require     => File[$webroot],
    }
  } else {
    # Install zip file from source
    file { 'mini.zip':
      source  => $source,
      path    => "${webroot}/mini.zip",
      notify  => Exec['unzip'],
      require => File[$webroot],
    }
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
    ensure  => directory,
    require => Class['apache'],
  }

  # Symlink the version
  file { "${webroot}/index.html":
    ensure => 'link',
    target => 'mini/index-php.html',
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
