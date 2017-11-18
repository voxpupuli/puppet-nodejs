class nodejs::params {
  $npmrc_auth                  = undef
  $npmrc_config                = undef
  $nodejs_debug_package_ensure = 'absent'
  $nodejs_package_ensure       = 'present'
  $repo_enable_src             = false
  $repo_ensure                 = 'present'
  $repo_pin                    = undef
  $repo_priority               = 'absent'
  $repo_proxy                  = 'absent'
  $repo_proxy_password         = 'absent'
  $repo_proxy_username         = 'absent'
  $repo_url_suffix             = '0.10'
  $use_flags                   = ['npm', 'snapshot']

  # The full path to cmd.exe is required on Windows. The system32 fact is only
  # available from Facter 2.3
  $cmd_exe_path = $::osfamily ? {
    'Windows' => 'C:\Windows\system32\cmd.exe',
    default   => undef,
  }

  case $::osfamily {
    'Debian': {
      if $::operatingsystemrelease =~ /^6\.(\d+)/ {
        fail("The ${module_name} module is not supported on Debian Squeeze.")
      }
      elsif $::operatingsystemrelease =~ /^[789]\.(\d+)/ {
        $legacy_debian_symlinks    = false
        $manage_package_repo       = true
        $nodejs_debug_package_name = 'nodejs-dbg'
        $nodejs_dev_package_name   = undef
        $nodejs_dev_package_ensure = 'absent'
        $nodejs_package_name       = 'nodejs'
        $npm_package_ensure        = 'absent'
        $npm_package_name          = false
        $npm_path                  = '/usr/bin/npm'
        $repo_class                = '::nodejs::repo::nodesource'
      }
      elsif $::operatingsystemrelease =~ /^10.04$/ {
        $legacy_debian_symlinks    = false
        $manage_package_repo       = true
        $nodejs_debug_package_name = 'nodejs-dbg'
        $nodejs_dev_package_name   = undef
        $nodejs_dev_package_ensure = 'absent'
        $nodejs_package_name       = 'nodejs'
        $npm_package_ensure        = 'absent'
        $npm_package_name          = false
        $npm_path                  = '/usr/bin/npm'
        $repo_class                = '::nodejs::repo::nodesource'
      }
      elsif $::operatingsystemrelease =~ /^12.04$/ {
        $legacy_debian_symlinks    = false
        $manage_package_repo       = true
        $nodejs_debug_package_name = 'nodejs-dbg'
        $nodejs_dev_package_name   = 'nodejs-dev'
        $nodejs_dev_package_ensure = 'absent'
        $nodejs_package_name       = 'nodejs'
        $npm_package_ensure        = 'absent'
        $npm_package_name          = 'npm'
        $npm_path                  = '/usr/bin/npm'
        $repo_class                = '::nodejs::repo::nodesource'
      }
      elsif $::operatingsystemrelease =~ /^14.04$/ {
        $legacy_debian_symlinks    = false
        $manage_package_repo       = true
        $nodejs_debug_package_name = 'nodejs-dbg'
        $nodejs_dev_package_name   = 'nodejs-dev'
        $nodejs_dev_package_ensure = 'absent'
        $nodejs_package_name       = 'nodejs'
        $npm_package_ensure        = 'absent'
        $npm_package_name          = 'npm'
        $npm_path                  = '/usr/bin/npm'
        $repo_class                = '::nodejs::repo::nodesource'
      }
      elsif $::operatingsystemrelease =~ /^16.04$/ {
        $legacy_debian_symlinks    = false
        $manage_package_repo       = true
        $nodejs_debug_package_name = 'nodejs-dbg'
        $nodejs_dev_package_name   = 'nodejs-dev'
        $nodejs_dev_package_ensure = 'absent'
        $nodejs_package_name       = 'nodejs'
        $npm_package_ensure        = 'absent'
        $npm_package_name          = 'npm'
        $npm_path                  = '/usr/bin/npm'
        $repo_class                = '::nodejs::repo::nodesource'
      }
      else {
        warning("The ${module_name} module might not work on ${::operatingsystem} ${::operatingsystemrelease}. Sensible defaults will be attempted.")
        $legacy_debian_symlinks    = false
        $manage_package_repo       = true
        $nodejs_debug_package_name = 'nodejs-dbg'
        $nodejs_dev_package_name   = 'nodejs-dev'
        $nodejs_dev_package_ensure = 'absent'
        $nodejs_package_name       = 'nodejs'
        $npm_package_ensure        = 'absent'
        $npm_package_name          = 'npm'
        $npm_path                  = '/usr/bin/npm'
        $repo_class                = '::nodejs::repo::nodesource'
      }
    }
    'RedHat': {
      $legacy_debian_symlinks      = false

      if $::operatingsystemrelease =~ /^[5-7]\.(\d+)/ {
        $manage_package_repo       = true
        $nodejs_debug_package_name = 'nodejs-debuginfo'
        $nodejs_dev_package_name   = 'nodejs-devel'
        $nodejs_dev_package_ensure = 'absent'
        $nodejs_package_name       = 'nodejs'
        $npm_package_ensure        = 'absent'
        $npm_package_name          = 'npm'
        $npm_path                  = '/usr/bin/npm'
        $repo_class                = '::nodejs::repo::nodesource'
      }
      elsif ($::operatingsystem == 'Fedora') and (versioncmp($::operatingsystemrelease, '18') > 0) {
        $manage_package_repo       = true
        $nodejs_debug_package_name = 'nodejs-debuginfo'
        $nodejs_dev_package_name   = 'nodejs-devel'
        $nodejs_dev_package_ensure = 'absent'
        $nodejs_package_name       = 'nodejs'
        $npm_package_ensure        = 'absent'
        $npm_package_name          = 'npm'
        $npm_path                  = '/usr/bin/npm'
        $repo_class                = '::nodejs::repo::nodesource'
      }
      elsif ($::operatingsystem == 'Amazon') {
        $manage_package_repo       = true
        $nodejs_debug_package_name = 'nodejs-debuginfo'
        $nodejs_dev_package_name   = 'nodejs-devel'
        $nodejs_dev_package_ensure = 'absent'
        $nodejs_package_name       = 'nodejs'
        $npm_package_ensure        = 'absent'
        $npm_package_name          = 'npm'
        $npm_path                  = '/usr/bin/npm'
        $repo_class                = '::nodejs::repo::nodesource'
      }
      else {
        fail("The ${module_name} module is not supported on ${::operatingsystem} ${::operatingsystemrelease}.")
      }
    }
    'Suse': {
      $legacy_debian_symlinks    = false
      $manage_package_repo       = false
      $nodejs_debug_package_name = 'nodejs-debuginfo'
      $nodejs_dev_package_name   = 'nodejs-devel'
      $nodejs_dev_package_ensure = 'absent'
      $nodejs_package_name       = 'nodejs'
      $npm_package_ensure        = 'present'
      $npm_package_name          = 'npm'
      $npm_path                  = '/usr/bin/npm'
      $repo_class                = undef
    }
    'Archlinux': {
      $legacy_debian_symlinks    = false
      $manage_package_repo       = false
      $nodejs_debug_package_name = undef
      $nodejs_dev_package_name   = undef
      $nodejs_dev_package_ensure = 'absent'
      $nodejs_package_name       = 'nodejs'
      $npm_package_ensure        = 'present'
      $npm_package_name          = 'npm'
      $npm_path                  = '/usr/bin/npm'
      $repo_class                = undef
    }
    'FreeBSD': {
      $legacy_debian_symlinks    = false
      $manage_package_repo       = false
      $nodejs_debug_package_name = undef
      $nodejs_dev_package_name   = 'www/node-devel'
      $nodejs_dev_package_ensure = 'absent'
      $nodejs_package_name       = 'www/node'
      $npm_package_ensure        = 'present'
      $npm_package_name          = 'www/npm'
      $npm_path                  = '/usr/bin/npm'
      $repo_class                = undef
    }
    'OpenBSD': {
      $legacy_debian_symlinks    = false
      $manage_package_repo       = false
      $nodejs_debug_package_name = undef
      $nodejs_dev_package_name   = undef
      $nodejs_dev_package_ensure = 'absent'
      $nodejs_package_name       = 'node'
      $npm_package_ensure        = 'absent'
      $npm_package_name          = false
      $npm_path                  = '/usr/local/bin/npm'
      $repo_class                = undef
    }
    'Darwin': {
      $legacy_debian_symlinks    = false
      $manage_package_repo       = false
      $nodejs_debug_package_name = undef
      $nodejs_dev_package_name   = 'nodejs-devel'
      $nodejs_dev_package_ensure = 'absent'
      $nodejs_package_name       = 'nodejs'
      $npm_package_ensure        = 'present'
      $npm_package_name          = 'npm'
      $npm_path                  = '/opt/local/bin/npm'
      $repo_class                = undef
      Package { provider => 'macports' }
    }
    'Windows': {
      $legacy_debian_symlinks    = false
      $manage_package_repo       = false
      $nodejs_debug_package_name = undef
      $nodejs_dev_package_name   = undef
      $nodejs_dev_package_ensure = 'absent'
      $nodejs_package_name       = 'nodejs'
      $npm_package_ensure        = 'absent'
      $npm_package_name          = 'npm'
      $npm_path                  = '"C:\Program Files\nodejs\npm.cmd"'
      $repo_class                = undef
      Package { provider => 'chocolatey' }
    }
    # Gentoo was added as its own $::osfamily in Facter 1.7.0
    'Gentoo': {
      $legacy_debian_symlinks    = false
      $manage_package_repo       = false
      $nodejs_debug_package_name = undef
      $nodejs_dev_package_name   = undef
      $nodejs_dev_package_ensure = 'absent'
      $nodejs_package_name       = 'net-libs/nodejs'
      $npm_package_ensure        = 'absent'
      $npm_package_name          = false
      $npm_path                  = '/usr/bin/npm'
      $repo_class                = undef
    }
    'Linux': {
    # Before Facter 1.7.0 Gentoo did not have its own $::osfamily
      case $::operatingsystem {
        'Gentoo': {
          $legacy_debian_symlinks    = false
          $manage_package_repo       = false
          $nodejs_debug_package_name = undef
          $nodejs_dev_package_name   = undef
          $nodejs_dev_package_ensure = 'absent'
          $nodejs_package_name       = 'net-libs/nodejs'
          $npm_package_ensure        = 'absent'
          $npm_package_name          = false
          $npm_path                  = '/usr/bin/npm'
          $repo_class                = undef
        }
        'Amazon': {
          # this is here only for historical reasons:
          # old facter and Amazon Linux versions will run into this code path
          $legacy_debian_symlinks    = false
          $manage_package_repo       = true
          $nodejs_debug_package_name = 'nodejs-debuginfo'
          $nodejs_dev_package_name   = 'nodejs-devel'
          $nodejs_dev_package_ensure = 'absent'
          $nodejs_package_name       = 'nodejs'
          $npm_package_ensure        = 'absent'
          $npm_package_name          = 'npm'
          $npm_path                  = '/usr/bin/npm'
          $repo_class                = '::nodejs::repo::nodesource'
        }

        default: {
          fail("The ${module_name} module is not supported on an ${::operatingsystem} distribution.")
        }
      }
    }

    default: {
      fail("The ${module_name} module is not supported on a ${::osfamily} based system.")
    }
  }
}
