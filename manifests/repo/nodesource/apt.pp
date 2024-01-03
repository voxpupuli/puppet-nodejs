# PRIVATE CLASS: Do not use directly.
class nodejs::repo::nodesource::apt {
  $ensure     = $nodejs::repo::nodesource::ensure
  $pin        = $nodejs::repo::nodesource::pin
  $url_suffix = $nodejs::repo::nodesource::url_suffix

  include apt

  if ($ensure != 'absent') {
    apt::source { 'nodesource':
      key      => {
        'id'     => '6F71F525282841EEDAF851B42F59B5F99B1BE0B4',
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
