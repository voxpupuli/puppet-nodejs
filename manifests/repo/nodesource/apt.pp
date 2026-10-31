# PRIVATE CLASS: Do not use directly.
class nodejs::repo::nodesource::apt {
  $ensure     = $nodejs::repo::nodesource::ensure
  $priority   = $nodejs::repo::nodesource::priority
  $url_suffix = $nodejs::repo::nodesource::url_suffix

  include apt

  if ($ensure != 'absent') {
    apt::keyring { 'nodesource':
      source   => 'https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key',
      filename => 'nodesource-repo.gpg.key.asc',
    }

    apt::source { 'nodesource':
      source_format => 'sources',
      location      => ["https://deb.nodesource.com/node_${url_suffix}",],
      keyring       => '/etc/apt/keyrings/nodesource-repo.gpg.key.asc',
      release       => ['nodistro',],
      repos         => ['main',],
      types         => ['deb',],
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
    # deb822 format; ensure => 'absent' needs source_format to delete .sources
    # (puppetlabs-apt #1245, fixed in 11.3.0)
    apt::source { 'nodesource':
      ensure        => 'absent',
      source_format => 'sources',
    }
    # Legacy .list file from releases before the deb822 switch
    apt::setting { 'list-nodesource':
      ensure => 'absent',
    }
    apt::pin { 'nodesource':
      ensure => 'absent',
    }
    apt::keyring { 'nodesource':
      ensure   => 'absent',
      filename => 'nodesource-repo.gpg.key.asc',
    }
  }
}
