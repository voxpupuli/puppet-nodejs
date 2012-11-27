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

  # Work around issue: http://projects.puppetlabs.com/issues/15792
  if $::operatingsystem == 'Amazon' {
    $osfamily = 'RedHat'
  } else {
    $osfamily = $::osfamily
  }

  case $osfamily {
    'RedHat': {
      $node_pkg = 'nodejs-compat-symlinks'
      $npm_pkg  = 'npm'
      case $::operatingsystem {
        'Fedora': { $pkg_src = 'http://nodejs.tchol.org/repocfg/fedora/nodejs-stable-release.noarch.rpm' }
        'Amazon': { $pkg_src = 'http://nodejs.tchol.org/repocfg/amzn1/nodejs-stable-release.noarch.rpm' }
        default:  { $pkg_src = 'http://nodejs.tchol.org/repocfg/el/nodejs-stable-release.noarch.rpm' }
      }
    }
    'Debian': {
      $node_pkg = 'nodejs'
      $npm_pkg  = 'npm'
      $dev_pkg  = 'nodejs-dev'
    }
    'Suse': {
      $node_pkg = 'nodejs'
      $npm_pkg  = 'npm'
      $dev_pkg  = 'nodejs-devel'
    }
    default: {
      fail("Class nodejs does not support ${::operatingsystem}")
    }
  }
}
