# Class: nodejs::parms
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Usage:
#
class nodejs::params {

  case $::operatingsystem {
    'Debian', 'Ubuntu': {
      $node_pkg = 'nodejs'
      $npm_pkg  = 'npm'
      $dev_pkg  = 'nodejs-dev'
    }

    'SLES', 'OpenSuSE': {
      $node_pkg = 'nodejs'
      $npm_pkg  = 'npm'
      $dev_pkg  = 'nodejs-devel'
    }

    'RedHat', 'CentOS': {
      $node_pkg = 'nodejs-compat-symlinks'
      $npm_pkg  = 'npm'
      $pkg_src  = 'http://nodejs.tchol.org/repocfg/el/nodejs-stable-release.noarch.rpm'
    }

    'Fedora': {
      $node_pkg = 'nodejs-compat-symlinks'
      $npm_pkg  = 'npm'
      $pkg_src  = 'http://nodejs.tchol.org/repocfg/fedora/nodejs-stable-release.noarch.rpm'
    }

    'Amazon': {
      $node_pkg = 'nodejs-compat-symlinks'
      $npm_pkg  = 'npm'
      $pkg_src  = 'http://nodejs.tchol.org/repocfg/amzn1/nodejs-stable-release.noarch.rpm'
    }

    default: {
      fail("Class nodejs does not support ${::operatingsystem}")
    }
  }

}
