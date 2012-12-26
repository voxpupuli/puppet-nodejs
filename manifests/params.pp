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

    'RedHat', 'CentOS', 'OEL', 'OracleLinux': {
      $majdistrelease = $::lsbmajdistrelease ? {
        ''      => regsubst($::operatingsystemrelease,'^(\d+)\.(\d+)','\1'),
        default => $::lsbmajdistrelease,
      }
      $node_pkg = 'nodejs-compat-symlinks'
      $npm_pkg  = 'npm'
      $baseurl  = 'http://patches.fedorapeople.org/oldnode/stable/el$releasever/$basearch/'
      $gpgcheck = $majdistrelease ? {
        '5'     => 0,
        default => 1,
      }
    }

    'Fedora': {
      $node_pkg = 'nodejs-compat-symlinks'
      $npm_pkg  = 'npm'
      $gpgcheck = 1
      $baseurl  = 'http://patches.fedorapeople.org/oldnode/stable/f$releasever/$basearch/'
    }

    'Amazon': {
      $node_pkg = 'nodejs-compat-symlinks'
      $npm_pkg  = 'npm'
      $gpgcheck = 1
      $baseurl  = 'http://patches.fedorapeople.org/oldnode/stable/amzn1/$basearch/'
    }

    default: {
      fail("Class nodejs does not support ${::operatingsystem}")
    }
  }

}
