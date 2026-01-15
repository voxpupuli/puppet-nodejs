# PRIVATE CLASS: Do not use directly.
class nodejs::repo::nodesource::apt {
  $ensure     = $nodejs::repo::nodesource::ensure
  $pin        = $nodejs::repo::nodesource::pin
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
      types         => ['deb',],
      require       => Apt::Keyring['nodesource'],
    }

    apt::pin { 'nodesource':
      origin => 'deb.nodesource.com',
      pin    => $pin,
    }

    Apt::Source['nodesource'] -> Package<| tag == 'nodesource_repo' |>
    Class['Apt::Update'] -> Package<| tag == 'nodesource_repo' |>
  }

  else {
    apt::source { 'nodesource':
      ensure => 'absent',
    }
  }
}
