# PRIVATE CLASS: Do not use directly.
class nodejs::repo::nodesource::apt {

  $enable_src = $nodejs::repo::nodesource::enable_src
  $ensure     = $nodejs::repo::nodesource::ensure
  $pin        = $nodejs::repo::nodesource::pin
  $release    = $nodejs::repo::nodesource::release
  $url_suffix = $nodejs::repo::nodesource::url_suffix

  include ::apt

  if ($ensure != 'absent') {
    apt::source { 'nodesource':
      include  => {
        'src' => $enable_src,
      },
      key      => {
        'id'     => '9FD3B784BC1C6FC31A8A0A1C1655A0AB68576280',
        'source' => 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key',
      },
      location => "https://deb.nodesource.com/node_${url_suffix}",
      pin      => $pin,
      release  => $release,
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
