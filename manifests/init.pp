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
class nodejs(
  $dev_package = false,
  $proxy       = ''
) inherits nodejs::params {

  case $::operatingsystem {
    'Debian': {
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

    'Ubuntu': {
      include 'apt'

      # Only use PPA when necessary.
      if $::lsbdistcodename != 'Precise'{
        apt::ppa { 'ppa:chris-lea/node.js':
          before => Anchor['nodejs::repo'],
        }
      }
      package { 'nodejs':
        name    => $nodejs::params::node_pkg,
        ensure  => present,
        require => Anchor['nodejs::repo']
      }

      package { 'npm':
        name    => $nodejs::params::npm_pkg,
        ensure  => present,
        require => Anchor['nodejs::repo']
      }      
      
      if $dev_package and $nodejs::params::dev_pkg {
        package { 'nodejs-dev':
          name    => $nodejs::params::dev_pkg,
          ensure  => present,
          require => Anchor['nodejs::repo']
        }
      }
    }

    'Fedora', 'RedHat', 'CentOS', 'Amazon': {
      # wget from https://github.com/maestrodev/puppet-wget
      include wget
      wget::fetch { "nodejs":
        source => $pkg_src,
        destination => $nodejs_tarball,
        notify => Exec['nodejs_unpack'],
      } ->
      exec { 'nodejs_unpack':
         command => "tar zxf ${nodejs_tarball}",
         cwd     => '/usr/local',
         creates => $install_dir,
      } ->
      file { '/usr/local/node': 
        ensure => link,
        target => $install_dir
      } ->
      file { '/usr/bin/node': 
        ensure => link,
        target => '/usr/local/node/bin/node',
      } ->
      file { '/usr/bin/npm': 
        ensure => link,
        target => '/usr/local/node/bin/npm',
      } ->
      file { '/usr/bin/node-waf': 
        ensure => link,
        target => '/usr/local/node/bin/node-waf',
      }
      
    }

    default: {
      fail("Class nodejs does not support ${::operatingsystem}")
    }
  }

  # anchor resource provides a consistent dependency for prereq.
  anchor { 'nodejs::repo': }

  
  if $proxy {
    exec { 'npm_proxy':
      command => "npm config set proxy ${proxy}",
      path    => $::path,
      require => Package['npm'],
    }
  }

  

}
