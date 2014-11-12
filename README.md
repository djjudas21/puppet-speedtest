# speedtest

#### Table of Contents

1. [Overview](#overview)
2. [Usage - Configuration options and additional functionality](#usage)
3. [Limitations - OS compatibility, etc.](#limitations)
4. [Development - Guide for contributing to the module](#development)

## Overview

This module installs [Ookla Speedtest Mini](http://www.speedtest.net/mini.php).

Speedtest Mini is free but not freely redistributable and therefore cannot be
included with this module. To obtain Speedtest Mini, you will need to create
an account with Ookla and download `mini.zip` from their website. This module
will then use `mini.zip` to install and configure Speedtest Mini.

This module relies on `puppetlabs/apache` to handle the web server and on
`puppetlabs/firewall` to install the optional firewall rule.

## Usage

It is recommended that you use a wrapper class to call the `speedtest` class.
This wrapper class should hold your copy of `mini.zip` and present it to
`speedtest`.

```puppet
class site_speedtest {
  class { 'speedtest':
    source   => 'puppet:///modules/site_speedtest/mini.zip',
    webroot  => '/var/www/speedtest',
    vhost    => 'speedtest.example.com',
    firewall => true,
  }
}
```

### `source`
Path to `mini.zip` using the Puppet fileserver. Required.

### `webroot`
Path to the web root on your system. Optional, defaults to `/var/www/speedtest`.

### `vhost`
Domain name from which Speedtest Mini should be served. Optional, defaults to `$::fqdn`

### `firewall`
Whether to make a firewall exception on port 80. Optional, defaults to `false`

## Limitations

This module was written for use with CentOS 6. It has not been tested on any other
platforms but it ought to work pretty much anywhere that supports Apache. Please
let me know if it works on other distributions.

## Development

Feel free to send issues and pull requests to improve this simple module.
