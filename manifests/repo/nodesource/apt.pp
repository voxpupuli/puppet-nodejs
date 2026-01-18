# PRIVATE CLASS: Do not use directly.
class nodejs::repo::nodesource::apt {
  $ensure     = $nodejs::repo::nodesource::ensure
  $priority   = $nodejs::repo::nodesource::priority
  $url_suffix = $nodejs::repo::nodesource::url_suffix

  include apt

  if ($ensure != 'absent') {
    apt::keyring { 'nodesource':
      source   => 'https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key',
      dir      => '/usr/share/keyrings',
      filename => 'nodesource-repo.gpg.key.asc',
    }

    apt::source { 'nodesource':
      source_format => 'sources',
      location      => ["https://deb.nodesource.com/node_${url_suffix}",],
      keyring       => '/usr/share/keyrings/nodesource-repo.gpg.key.asc',
      release       => ['nodistro',],
      repos         => ['main',],
      types         => ['deb','deb-src',],
      require       => Apt::Keyring['nodesource'],
    }

    apt::pin { 'nodesource':
      origin   => 'deb.nodesource.com',
      priority => $priority,
    }

    Apt::Source['nodesource'] -> Package<| tag == 'nodesource_repo' |>
    Class['Apt::Update'] -> Package<| tag == 'nodesource_repo' |>
  }

  else {
    apt::source { 'nodesource':
      ensure => 'absent',
    }
    apt::pin { 'nodesource':
      ensure => 'absent',
    }
    apt::keyring { 'nodesource':
      ensure   => 'absent',
      dir      => '/usr/share/keyrings',
      filename => 'nodesource-repo.gpg.key.asc',
    }
    file { '/etc/apt/sources.list.d/nodesource.sources':
      ensure => 'absent',
      notify => Class['Apt::Update'],
    }
  }
}
