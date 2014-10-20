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
      $baseurl  = 'http://patches.fedorapeople.org/oldnode/stable/el$releasever/$basearch/'

      $software_collections = false
      $scl_enable = false
      $scl_node_pkg = 'nodejs010'
      $scl_npm_pkg = 'nodejs010-npm'
      $scl_npm_cmd = '/usr/bin/scl enable nodejs010'
    }

    'Fedora': {
      $node_pkg = 'nodejs-compat-symlinks'
      $npm_pkg  = 'npm'
      $gpgcheck = 1
      $baseurl  = 'http://patches.fedorapeople.org/oldnode/stable/f$releasever/$basearch/'
    }

    'Amazon': {
      $node_pkg = 'nodejs'
      $npm_pkg  = 'npm'
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
