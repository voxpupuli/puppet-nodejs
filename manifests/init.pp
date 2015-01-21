# Class: nodejs
#
# Parameters:
#
# node_pkg: (string) the name of the package to install
# npm_pkg : (string) the name of the package that provides npm
# dev_pkg : (string) the name of the NodeJS development package to install
# dev_package: (bool) whether to install the dev_pkg or not
# manage_repo: (bool) whether to manage the repository
# proxy: (string) the HTTP proxy to use
# version: (string) the version of NodeJS (and associated packages) to install
#
# Actions:
#
# Requires:
#
# Usage:
# To install the default NodeJS packages as determined by your operating system
# (and as codified in nodejs::params), you can accept the default values:
#
# include nodejs
# class { 'nodejs': }
#
# To install a specific package name, you can override the parameter values. The
# following example installs NodeJS from Software Collections on a Red Hat-derived
# system:
#
# class { 'nodejs':
#   node_pkg    => 'nodejs010',
#   npm_pkg     => 'nodejs010-npm',
#   dev_pkg     => 'nodejs010-devel',
#   dev_package => true,
# }
#
class nodejs(
  $node_pkg    = $::nodejs::params::node_pkg,
  $npm_pkg     = $::nodejs::params::npm_pkg,
  $dev_pkg     = $::nodejs::params::dev_pkg,
  $dev_package = false,
  $manage_repo = false,
  $proxy       = '',
  $version     = 'present'
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
        # Only add apt source if we're managing the repo
        include 'apt'
        # Add the NodeSource repo
        apt::source { 'nodesource':
          location   => 'https://deb.nodesource.com/node',
          repos      => 'main',
          key        => '68576280',
          key_source => 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key',
          before     => Anchor['nodejs::repo'],
        }

        if $dev_package {
            # Add the NodeSource devel repo
            apt::source { 'nodesource-devel':
              location   => 'https://deb.nodesource.com/node-devel',
              repos      => 'main',
              key        => '68576280',
              key_source => 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key',
              before     => Anchor['nodejs::repo'],
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

    'Archlinux': {
      # Archlinux does not need any special repos for nodejs
    }

    default: {
      fail("Class nodejs does not support ${::operatingsystem}")
    }
  }

  # anchor resource provides a consistent dependency for prereq.
  anchor { 'nodejs::repo': }

  package { 'nodejs':
    ensure  => $version,
    name    => $node_pkg,
    require => Anchor['nodejs::repo']
  }

  case $::operatingsystem {
    'Ubuntu': {
      # The PPA we are using on Ubuntu includes NPM in the nodejs package, hence
      # we must not install it separately
      $npm_require = 'Package[nodejs]'
    }

    'Gentoo': {
      # Gentoo installes npm with the nodejs package when configured properly.
      # We use the gentoo/portage module since it is expected to be
      # available on all gentoo installs.
      $npm_require = 'Package[nodejs]'
      package_use { $nodejs::params::node_pkg:
        ensure  => present,
        use     => 'npm',
        require => Anchor['nodejs::repo'],
      }
    }

    'Archlinux': {
      $npm_require = 'Package[nodejs]'
      # Archlinux installes npm with the nodejs package.
    }

    default: {
      package { 'npm':
        ensure  => present,
        name    => $npm_pkg,
        require => Anchor['nodejs::repo']
      }
      $npm_require = 'Package[npm]'
    }
  }

  if $proxy {
    exec { 'npm_proxy':
      command => "npm config set proxy ${proxy}",
      path    => $::path,
      require => $npm_require,
    }
  }

  if $dev_package and $dev_pkg {
    package { 'nodejs-dev':
      ensure  => $version,
      name    => $dev_pkg,
      require => Anchor['nodejs::repo']
    }
  }

}
