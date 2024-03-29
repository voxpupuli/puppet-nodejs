# PRIVATE CLASS: do not call directly
class nodejs::install {
  $npmrc_auth = $nodejs::npmrc_auth
  $npmrc_config = $nodejs::npmrc_config

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  # npm is a Gentoo USE flag
  if $facts['os']['name'] == 'Gentoo' and $nodejs::manage_nodejs_package {
    package_use { $nodejs::nodejs_package_name:
      ensure => present,
      target => 'nodejs-flags',
      use    => $nodejs::use_flags,
      before => Package[$nodejs::nodejs_package_name],
    }
  }

  Package { provider => $nodejs::package_provider }

  # nodejs
  if $nodejs::manage_nodejs_package {
    package { $nodejs::nodejs_package_name:
      ensure => $nodejs::nodejs_package_ensure,
      tag    => 'nodesource_repo',
    }
  }

  # nodejs-development
  if $nodejs::manage_nodejs_package and $nodejs::nodejs_dev_package_name {
    package { $nodejs::nodejs_dev_package_name:
      ensure => $nodejs::nodejs_dev_package_ensure,
      tag    => 'nodesource_repo',
    }
  }

  # nodejs-debug
  if $nodejs::nodejs_debug_package_name {
    package { $nodejs::nodejs_debug_package_name:
      ensure => $nodejs::nodejs_debug_package_ensure,
      tag    => 'nodesource_repo',
    }
  }

  # npm
  if $nodejs::npm_package_name and $nodejs::npm_package_name != false {
    # the nodesource nodejs packages provide "npm" which makes Puppet
    # try to uninstall them again
    if $nodejs::npm_package_ensure == absent and $nodejs::manage_package_repo == true and $nodejs::repo_class == 'nodejs::repo::nodesource' {
      $allow_virtual = false
    } else {
      $allow_virtual = undef
    }
    package { $nodejs::npm_package_name:
      ensure        => $nodejs::npm_package_ensure,
      allow_virtual => $allow_virtual,
      tag           => 'nodesource_repo',
    }
  }

  if $facts['os']['name'] != 'Windows' {
    file { 'root_npmrc':
      ensure  => 'file',
      path    => "${facts['root_home']}/.npmrc",
      content => template('nodejs/npmrc.erb'),
      owner   => 'root',
      group   => '0',
      mode    => '0600',
    }
  }
}
