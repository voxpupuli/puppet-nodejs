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
      class { 'apt': }

      apt::source { 'sid':
        location    => 'http://ftp.us.debian.org/debian/',
        release     => 'sid',
        repos       => 'main',
        include_src => false,
        before      => Package['nodejs'],
      }
    }

    'Ubuntu': {
      class { 'apt': }

      package { 'python-software-properties':
        ensure => present,
      }

      apt::ppa { 'ppa:chris-lea/node.js':
        before => Package['nodejs'],
      }
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
    command  => 'curl http://npmjs.org/install.sh | sed "s/<\/dev\/tty//g" > /tmp/install_$$.sh; chmod 755 /tmp/install_$$.sh; /tmp/install_$$.sh',
    unless    => 'which npm',
    path      => $::path,
    logoutput => 'on_failure',
    require   => Package['nodejs', 'curl'],
  }

}
