# PRIVATE CLASS: Do not use directly.
class nodejs::repo::nodesource::yum {
  $baseurl        = $nodejs::repo::nodesource::baseurl
  $descr          = $nodejs::repo::nodesource::descr
  $enable_src     = $nodejs::repo::nodesource::enable_src
  $ensure         = $nodejs::repo::nodesource::ensure
  $priority       = $nodejs::repo::nodesource::priority
  $proxy          = $nodejs::repo::nodesource::proxy
  $proxy_password = $nodejs::repo::nodesource::proxy_password
  $proxy_username = $nodejs::repo::nodesource::proxy_username
  $source_baseurl = $nodejs::repo::nodesource::source_baseurl
  $source_descr   = $nodejs::repo::nodesource::source_descr

  $yum_source_enabled = $enable_src ? {
    true    => '1',
    default => '0',
  }

  $yum_failovermethod = (versioncmp($facts['os']['release']['major'], '8') >= 0 and $priority == 'absent') ? {
    true    => 'absent',
    default => 'priority',
  }

  if ($ensure == 'present') {
    if versioncmp($facts['os']['release']['major'], '8') >= 0 {
      file { 'dnf_module':
        ensure => file,
        path   => '/etc/dnf/modules.d/nodejs.module',
        group  => '0',
        mode   => '0644',
        owner  => 'root',
        source => "puppet:///modules/${module_name}/repo/dnf/nodejs.module",
      }
    }

    yumrepo { 'nodesource':
      descr          => $descr,
      baseurl        => $baseurl,
      enabled        => '1',
      failovermethod => $yum_failovermethod,
      gpgkey         => 'file:///etc/pki/rpm-gpg/NODESOURCE-GPG-SIGNING-KEY-EL',
      gpgcheck       => '1',
      priority       => $priority,
      proxy          => $proxy,
      proxy_password => $proxy_password,
      proxy_username => $proxy_username,
      require        => File['/etc/pki/rpm-gpg/NODESOURCE-GPG-SIGNING-KEY-EL'],
    }

    yumrepo { 'nodesource-source':
      descr          => $source_descr,
      baseurl        => $source_baseurl,
      enabled        => $yum_source_enabled,
      failovermethod => $yum_failovermethod,
      gpgkey         => 'file:///etc/pki/rpm-gpg/NODESOURCE-GPG-SIGNING-KEY-EL',
      gpgcheck       => '1',
      priority       => $priority,
      proxy          => $proxy,
      proxy_password => $proxy_password,
      proxy_username => $proxy_username,
      require        => File['/etc/pki/rpm-gpg/NODESOURCE-GPG-SIGNING-KEY-EL'],
    }

    file { '/etc/pki/rpm-gpg/NODESOURCE-GPG-SIGNING-KEY-EL':
      ensure => file,
      group  => '0',
      mode   => '0644',
      owner  => 'root',
      source => "puppet:///modules/${module_name}/repo/nodesource/NODESOURCE-GPG-SIGNING-KEY-EL",
    }
  }

  else {
    yumrepo { 'nodesource':
      ensure => 'absent',
    }

    yumrepo { 'nodesource-source':
      ensure => 'absent',
    }

    if versioncmp($facts['os']['release']['major'], '8') >= 0 {
      file { 'dnf_module':
        ensure => absent,
        path   => '/etc/dnf/modules.d/nodejs.module',
      }
    }
  }
}
