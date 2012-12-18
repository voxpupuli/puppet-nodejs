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
class nodejs::params($version = '0.8.16') {

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

    'RedHat', 'CentOS', 'Fedora', 'Amazon': {
      $node_arch = $::architecture ? { 'x86_64' => 'x64', default => 'x86' }
      # These pkg names will not be needed until a new repo becomes available
      $node_pkg       = 'nodejs-compat-symlinks'
      $npm_pkg        = 'npm'
      $pkg_src        = "http://nodejs.org/dist/v${version}/node-v${version}-linux-${node_arch}.tar.gz"
      $nodejs_tarball = "/usr/local/src/node-v${version}-linux-${node_arch}.tar.gz"
      $install_dir    = "/usr/local/node-v${version}-linux-${node_arch}"
    }

    default: {
      fail("Class nodejs does not support ${::operatingsystem}")
    }
  }

}
