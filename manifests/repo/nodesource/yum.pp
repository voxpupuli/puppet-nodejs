# PRIVATE CLASS: Do not use directly.
class nodejs::repo::nodesource::yum {
  $ensure         = $nodejs::repo::nodesource::ensure
  $priority       = $nodejs::repo::nodesource::priority
  $proxy          = $nodejs::repo::nodesource::proxy
  $proxy_password = $nodejs::repo::nodesource::proxy_password
  $proxy_username = $nodejs::repo::nodesource::proxy_username
  $url_suffix     = $nodejs::repo::nodesource::url_suffix

  $yum_failovermethod = (versioncmp($facts['os']['release']['major'], '8') >= 0 and $priority == 'absent') ? {
    true    => 'absent',
    default => 'priority',
  }

  # EL10 and later use DNF5, which has no module support.
  $manage_dnf_module = versioncmp($facts['os']['release']['major'], '8') >= 0 and versioncmp($facts['os']['release']['major'], '10') < 0

  if ($ensure == 'present') {
    if $manage_dnf_module {
      file { 'dnf_module':
        ensure => file,
        path   => '/etc/dnf/modules.d/nodejs.module',
        group  => '0',
        mode   => '0644',
        owner  => 'root',
        source => "puppet:///modules/${module_name}/repo/dnf/nodejs.module",
      }

      $module_hotfixes = true
    } else {
      $module_hotfixes = undef
    }

    yumrepo { 'nodesource':
      descr           => 'Node.js Packages - $basearch',
      baseurl         => "https://rpm.nodesource.com/pub_${url_suffix}/nodistro/nodejs/\$basearch",
      enabled         => '1',
      failovermethod  => $yum_failovermethod,
      gpgkey          => 'file:///etc/pki/rpm-gpg/NODESOURCE-GPG-SIGNING-KEY-EL',
      gpgcheck        => '1',
      module_hotfixes => $module_hotfixes,
      priority        => $priority,
      proxy           => $proxy,
      proxy_password  => $proxy_password,
      proxy_username  => $proxy_username,
      require         => File['/etc/pki/rpm-gpg/NODESOURCE-GPG-SIGNING-KEY-EL'],
    }

    $gpg_source = 'ns-operations-public.key'

    file { '/etc/pki/rpm-gpg/NODESOURCE-GPG-SIGNING-KEY-EL':
      ensure => file,
      group  => '0',
      mode   => '0644',
      owner  => 'root',
      source => "puppet:///modules/${module_name}/repo/nodesource/${gpg_source}",
    }
  }

  else {
    yumrepo { 'nodesource':
      ensure => 'absent',
    }

    if $manage_dnf_module {
      file { 'dnf_module':
        ensure => absent,
        path   => '/etc/dnf/modules.d/nodejs.module',
      }
    }
  }
}
