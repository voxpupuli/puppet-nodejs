# == Define: nodejs::instance
#
# Create a new nodejs instance
#
# === Parameters
#
# [*ensure*]
#   Configure/unconfigure nodejs instance
#
# [*user*]
#   User that runs nodejs
#
# [*root_dir*]
#   Nodejs Application root directory
#
# [*script*]
#   Script to run
#
define nodejs::instance(
  $ensure = 'present',
  $user = 'nodejs',
  $root_dir = '/var/lib/nodejs',
  $script = 'app.js',
) {

  user{$user:
    ensure => $ensure,
    home   => $root_dir,
    system => true,
  }

  group{$user:
    ensure => $ensure,
    system => true,
  }

  file{"/etc/init.d/nodejs-${name}":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0756',
    content => template('nodejs/nodejs.init.erb'),
  }

  $root_dir_ensure = $ensure ? { 'present' => 'directory', default => 'absent' }
  file{$root_dir:
    ensure => $root_dir_ensure,
    owner  => $user,
    group  => $user,
    mode   => '0775',
  }

  $service_ensure = $ensure ? {
    'present' => 'running',
    default   => 'stopped',
  }
  $service_enable = $ensure ? {
    'present' => true,
    default   => false,
  }
  service{"nodejs-${name}":
    ensure => $service_ensure,
    enable => $service_enable,
  }

  if $ensure == 'present' {
    User[$user] -> File[$root_dir] -> Service["nodejs-${name}"]
    File["/etc/init.d/nodejs-${name}"] -> Service["nodejs-${name}"]
  } else {
    Service["nodejs-${name}"] -> File[$root_dir] -> User[$user]
    Service["nodejs-${name}"] -> File["/etc/init.d/nodejs-${name}"]
  }

}
