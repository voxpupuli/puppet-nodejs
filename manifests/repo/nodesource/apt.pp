# PRIVATE CLASS: Do not use directly.
class nodejs::repo::nodesource::apt {
  $ensure     = $nodejs::repo::nodesource::ensure
  $pin        = $nodejs::repo::nodesource::pin
  $url_suffix = $nodejs::repo::nodesource::url_suffix

  include apt

  if ($ensure != 'absent') {
    apt::source { 'nodesource':
      key      => {
        'name'   => 'nodesource-repo.gpg.key',
        'source' => 'https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key',
      },
      location => "https://deb.nodesource.com/node_${url_suffix}",
      pin      => $pin,
      release  => 'nodistro',
      repos    => 'main',
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
