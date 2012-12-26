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
  $proxy       = ''
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

    'Fedora', 'RedHat', 'CentOS', 'OEL', 'OracleLinux', 'Amazon': {
      package { 'nodejs-stable-release':
        ensure => absent,
        before => Yumrepo['nodejs-stable'],
      }

      yumrepo { 'nodejs-stable':
        descr    => 'Stable releases of Node.js',
        baseurl  => $nodejs::params::baseurl,
        enabled  => 1,
        gpgcheck => $nodejs::params::gpgcheck,
        gpgkey   => 'http://patches.fedorapeople.org/oldnode/stable/RPM-GPG-KEY-tchol',
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
      ensure  => present,
      require => Anchor['nodejs::repo']
    }
  }

}
