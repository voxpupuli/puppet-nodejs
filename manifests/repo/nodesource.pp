# PRIVATE CLASS: Do not use directly
class nodejs::repo::nodesource {
  $ensure         = $nodejs::repo_ensure
  $pin            = $nodejs::repo_pin
  $priority       = $nodejs::repo_priority
  $proxy          = $nodejs::repo_proxy
  $proxy_password = $nodejs::repo_proxy_password
  $proxy_username = $nodejs::repo_proxy_username

  $url_suffix     = "${nodejs::repo_version}.x"

  case $facts['os']['family'] {
    'RedHat': {
      contain 'nodejs::repo::nodesource::yum'
    }
    'Debian': {
      contain 'nodejs::repo::nodesource::apt'
    }
    default: {
      if ($ensure == 'present') {
        fail("Unsupported managed NodeSource repository for osfamily: ${facts['os']['family']}, operatingsystem: ${facts['os']['name']}.")
      }
    }
  }
}
