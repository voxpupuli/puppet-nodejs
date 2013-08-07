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
  $manage_repo = false,
  $proxy       = ''
) inherits nodejs::params {
  #input validation
  validate_bool($dev_package)
  validate_bool($manage_repo)

  case $::operatingsystem {
    'Debian': {
      if $manage_repo {
        #only add apt source if we're managing the repo
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
    }

    'Ubuntu': {
      if $manage_repo {
        #only add apt source if we're managing the repo
        include 'apt'
        # Only use PPA when necessary.
        if $::lsbdistcodename != 'Precise'{
          apt::ppa { 'ppa:chris-lea/node.js':
            before => Anchor['nodejs::repo'],
          }
        }

        apt::ppa { 'ppa:chris-lea/node.js-devel':
          before => Anchor['nodejs::repo'],
        }
      }
    }

    'SLES', 'OpenSuSE': {
      if $manage_repo {
        #only add zypper source if we're managing the repo
        include 'zypprepo'

        zypprepo { 'Cloud_OpenStack_Grizzly':
          baseurl => 'http://download.opensuse.org/repositories/Cloud:/OpenStack:/Grizzly/SLE_11_SP2/',
          enabled => 1,
          autorefresh => 1,
          name => 'OpenStack Grizzly (Stable branch) (SLE_11_SP2)',
          gpgcheck => 0,
          gpgkey => 'http://download.opensuse.org/repositories/Cloud:/OpenStack:/Grizzly/SLE_11_SP2/repodata/repomd.xml.key',
          keeppackages => 1,
          type => 'rpm-md',
          before   => Anchor['nodejs::repo']
        }
      }
    } 

    'Fedora', 'RedHat', 'CentOS', 'OEL', 'OracleLinux', 'Amazon': {
      if $manage_repo {
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
        file {'nodejs_repofile':
          ensure  => 'file',
          before  => Anchor['nodejs::repo'],
          group   => 'root',
          mode    => '0444',
          owner   => 'root',
          path    => '/etc/yum.repos.d/nodejs-stable.repo',
          require => Yumrepo['nodejs-stable']
        }
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

  if $nodejs::params::node_pkg != $nodejs::params::npm_pkg {
    package { $nodejs::params::npm_pkg:
      name    => $nodejs::params::npm_pkg,
      ensure  => present,
      require => Anchor['nodejs::repo']
    }
  }

  if $proxy {
    exec { 'npm_proxy':
      command => "npm config set proxy ${proxy}",
      path    => $::path,
      require => Package[$nodejs::params::npm_pkg],
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
