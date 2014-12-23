# Class: nodejs::parms
#
# Parameters:
# None!
#
# Actions:
# None!
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

    'RedHat', 'Scientific', 'CentOS', 'OEL', 'OracleLinux': {
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
      $npm_pkg  = 'npm'
      $dev_pkg  = 'nodejs-devel'
      $baseurl  = 'http://patches.fedorapeople.org/oldnode/stable/el$releasever/$basearch/'
    }

    'Fedora': {
      $node_pkg = 'nodejs-compat-symlinks'
      $npm_pkg  = 'npm'
      $dev_pkg  = 'nodejs-devel'
      $gpgcheck = 1
      $baseurl  = 'http://patches.fedorapeople.org/oldnode/stable/f$releasever/$basearch/'
    }

    'Amazon': {
      $node_pkg = 'nodejs'
      $npm_pkg  = 'npm'
      $dev_pkg  = 'nodejs-devel'
      $gpgcheck = 1
      $baseurl  = 'http://patches.fedorapeople.org/oldnode/stable/amzn1/$basearch/'
    }

    'Gentoo': {
      $node_pkg = 'net-libs/nodejs'
    }

    'Archlinux': {
      $node_pkg = 'nodejs'
    }

    default: {
      fail("Class nodejs does not support ${::operatingsystem}")
    }
  }

}
