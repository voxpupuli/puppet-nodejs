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
  $node_pkg             = $::nodejs::params::node_pkg,
  $npm_pkg              = $::nodejs::params::npm_pkg,
  $dev_pkg              = $::nodejs::params::dev_pkg,
  $dev_package          = false,
  $manage_repo          = false,
  $proxy                = '',
  $version              = 'present',
  $software_collections = $::nodejs::params::software_collections,
  $scl_enable           = $::nodejs::params::scl_enable,
) inherits nodejs::params {
  #input validation
  validate_bool($dev_package)
  validate_bool($manage_repo)
  validate_bool($software_collections)
  validate_bool($scl_enable)

  # Software Collections use a different name
  if $software_collections {
    $real_node_pkg = $::nodejs::params::scl_node_pkg
    $real_npm_pkg  = $::nodejs::params::scl_npm_pkg
    $real_dev_pkg  = $::nodejs::params::scl_dev_pkg
  } else {
    $real_node_pkg = $node_pkg
    $real_npm_pkg  = $npm_pkg
    $real_dev_pkg  = $dev_pkg
  }

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
        # Only add apt source if we're managing the repo
        include 'apt'
        # Only use PPA when necessary.
        apt::ppa { 'ppa:chris-lea/node.js':
          before => Anchor['nodejs::repo'],
        }

        if $dev_package {
            apt::ppa { 'ppa:chris-lea/node.js-devel':
              before => Anchor['nodejs::repo'],
            }
        }
      }
    }

    'Fedora', 'RedHat', 'Scientific', 'CentOS', 'OEL', 'OracleLinux', 'Amazon': {
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

    'Gentoo': {
      # Gentoo does not need any special repos for nodejs
    }

    default: {
      fail("Class nodejs does not support ${::operatingsystem}")
    }
  }

  # anchor resource provides a consistent dependency for prereq.
  anchor { 'nodejs::repo': }

  package { 'nodejs':
    ensure  => $version,
    name    => $real_node_pkg,
    require => Anchor['nodejs::repo']
  }

  case $::operatingsystem {
    'Ubuntu': {
      # The PPA we are using on Ubuntu includes NPM in the nodejs package, hence
      # we must not install it separately
    }

    'Gentoo': {
      # Gentoo installs npm with the nodejs package when configured properly.
      # We use the gentoo/portage module since it is expected to be
      # available on all gentoo installs.
      package_use { $nodejs::params::node_pkg:
        ensure  => present,
        use     => 'npm',
        require => Anchor['nodejs::repo'],
      }
    }

    default: {
      package { 'npm':
        ensure  => present,
        name    => $real_npm_pkg,
        require => Anchor['nodejs::repo']
      }
    }
  }

  if $proxy {
    exec { 'npm_proxy':
      command => "npm config set proxy ${proxy}",
      path    => $::path,
      require => Package['npm'],
    }
  }

  if $dev_package and $real_dev_pkg {
    package { 'nodejs-dev':
      ensure  => $version,
      name    => $real_dev_pkg,
      require => Anchor['nodejs::repo']
    }
  }

  if $software_collections and $scl_enable {
    # create a symlink in /etc/profile.d to run the
    # Software Collections enable script for node
    file { '/etc/profile.d/nodejs.sh':
      ensure  => link,
      target  => '/opt/rh/nodejs010/enable',
      require => Package['nodejs'],
    }

    # if we just installed nodejs from SCL, then the binaries
    # will not yet in our path.
    exec { 'nodejs010 enable':
      command => '/bin/true && source /opt/rh/nodejs010/enable',
      unless  => '/bin/echo $PATH | /bin/grep -q node',
      path    => '/bin:/usr/bin'
    }
  }

}
