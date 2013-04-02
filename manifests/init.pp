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
  $dev_package           = false,
  $proxy                 = '',
  $manage_repo           = true,
  $node_pkg              = $nodejs::params::node_pkg,
  $npm_pkg               = $nodejs::params::npm_pkg,
  $baseurl               = $nodejs::params::baseurl,
  $gpgcheck              = $nodejs::params::gpgcheck,
  $dev_pkg               = $nodejs::params::dev_pkg,
  $node_pkg_provides_npm = false,
) inherits nodejs::params {

  if ($manage_repo) {
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
          baseurl  => $baseurl,
          enabled  => 1,
          gpgcheck => $gpgcheck,
          gpgkey   => 'http://patches.fedorapeople.org/oldnode/stable/RPM-GPG-KEY-tchol',
          before   => Anchor['nodejs::repo'],
        }
      }

      default: {
        fail("Class nodejs does not support ${::operatingsystem}")
      }
    }
  }

  # anchor resource provides a consistent dependency for prereq.
  anchor { 'nodejs::repo': }

  package { 'nodejs':
    ensure  => present,
    name    => $node_pkg,
    require => Anchor['nodejs::repo']
  }

  if ($node_pkg_provides_npm == false) {
    package { 'npm':
      ensure  => present,
      name    => $npm_pkg,
      require => Anchor['nodejs::repo']
    }
  }

  if $proxy {
    exec { 'npm_proxy':
      command => "npm config set proxy ${proxy}",
      path    => $::path,
      require => Package['npm'],
    }
  }

  if $dev_package and $dev_pkg {
    package { 'nodejs-dev':
      ensure  => present,
      name    => $dev_pkg,
      require => Anchor['nodejs::repo']
    }
  }

}
