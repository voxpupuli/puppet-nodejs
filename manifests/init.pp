# Class: nodejs
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Usage:
#
class nodejs(
  $dev_package = false,
  $proxy       = '',
  $version     = 'present'
) inherits nodejs::params {

  case $::operatingsystem {
    'Debian': {
      include 'apt'

      apt::source { 'sid':
        location    => 'http://ftp.us.debian.org/debian/',
        release     => 'sid',
        repos       => 'main',
        pin         => 100,
        include_src => false,
        before      => Anchor['nodejs::repo'],
      }

    }

    'Ubuntu': {
      include 'apt'

      # Only use PPA when necessary.
      if $::lsbdistcodename != 'Precise'{
        apt::ppa { 'ppa:chris-lea/node.js':
          before => Anchor['nodejs::repo'],
        }
      }
    }

    'Fedora', 'RedHat', 'CentOS', 'Amazon': {
      package { 'nodejs-stable-release':
        ensure   => present,
        source   => $nodejs::params::pkg_src,
        provider => 'rpm',
        before   => Anchor['nodejs::repo'],
      }
    }

    default: {
      fail("Class nodejs does not support ${::operatingsystem}")
    }
  }

  # anchor resource provides a consistent dependency for prereq.
  anchor { 'nodejs::repo': }

  package { 'nodejs':
    name    => $nodejs::params::node_pkg,
    ensure  => present,
    require => Anchor['nodejs::repo']
  }

  package { 'npm':
    name    => $nodejs::params::npm_pkg,
    ensure  => present,
    require => Anchor['nodejs::repo']
  }

  if $proxy {
    exec { 'npm_proxy':
      command => "npm config set proxy ${proxy}",
      path    => $::path,
      require => Package['npm'],
    }
  }

  if $dev_package and $nodejs::params::dev_pkg {
    package { 'nodejs-dev':
      name    => $nodejs::params::dev_pkg,
      ensure  => $version,
      require => Anchor['nodejs::repo']
    }
  }

}
