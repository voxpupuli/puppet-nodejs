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
class nodejs {

  case $::operatingsystem {
    'Debian': {
      include 'apt'

      apt::source { 'sid':
        location    => 'http://ftp.us.debian.org/debian/',
        release     => 'sid',
        repos       => 'main',
        include_src => false,
        before      => Package['nodejs'],
      }
    }

    'Ubuntu': {
      include 'apt'

      apt::ppa { 'ppa:chris-lea/node.js':
        before => Package['nodejs'],
      }
    }

    default: {
      fail("Class nodejs does not support $::operatingsystem")
    }
  }

  package { 'nodejs':
    ensure  => present,
  }

  package { 'curl':
    ensure => present,
  }

  # npm installation is a hack since there's no packages:
  exec { 'install_npm':
    command   => 'curl http://npmjs.org/install.sh | sed "s/<\/dev\/tty//g" > /tmp/install_$$.sh; chmod 755 /tmp/install_$$.sh; /tmp/install_$$.sh',
    unless    => 'which npm',
    path      => $::path,
    logoutput => 'on_failure',
    require   => Package['nodejs', 'curl'],
  }

}
