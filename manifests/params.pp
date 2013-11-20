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

      # The PPA we are using on Ubuntu includes NPM in the nodejs package, hence
      # we must not install it separately
      if $::operatingsystem == 'ubuntu' {
        $install_npm = false
      } else {
        $install_npm = true
      }

    }

    'SLES', 'OpenSuSE': {
      $node_pkg = 'nodejs'
      $npm_pkg  = 'npm'
      $dev_pkg  = 'nodejs-devel'
      $install_npm = true
    }

    'RedHat', 'CentOS', 'OEL', 'OracleLinux': {
      $majdistrelease = $::lsbmajdistrelease ? {
        ''      => regsubst($::operatingsystemrelease,'^(\d+)\.(\d+)','\1'),
        default => $::lsbmajdistrelease,
      }

      case $majdistrelease {
        '5': {
          $gpgcheck = 0
          $node_pkg = 'nodejs-compat-symlinks'
        }
        default: {
          $gpgcheck = 1
          $node_pkg = 'nodejs'
        }
      }
      $npm_pkg     = 'npm'
      $baseurl     = 'http://patches.fedorapeople.org/oldnode/stable/el$releasever/$basearch/'
      $install_npm = true
    }

    'Fedora': {
      $node_pkg    = 'nodejs-compat-symlinks'
      $npm_pkg     = 'npm'
      $gpgcheck    = 1
      $baseurl     = 'http://patches.fedorapeople.org/oldnode/stable/f$releasever/$basearch/'
      $install_npm = true
    }

    'Amazon': {
      $node_pkg    = 'nodejs-compat-symlinks'
      $npm_pkg     = 'npm'
      $gpgcheck    = 1
      $baseurl     = 'http://patches.fedorapeople.org/oldnode/stable/amzn1/$basearch/'
      $install_npm = true
    }

    default: {
      fail("Class nodejs does not support ${::operatingsystem}")
    }
  }

}
