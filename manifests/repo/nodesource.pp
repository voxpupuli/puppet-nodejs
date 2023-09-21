# PRIVATE CLASS: Do not use directly
class nodejs::repo::nodesource {
  $enable_src     = $nodejs::repo_enable_src
  $ensure         = $nodejs::repo_ensure
  $pin            = $nodejs::repo_pin
  $priority       = $nodejs::repo_priority
  $proxy          = $nodejs::repo_proxy
  $proxy_password = $nodejs::repo_proxy_password
  $proxy_username = $nodejs::repo_proxy_username
  $release        = $nodejs::repo_release
  $url_suffix     = $nodejs::repo_url_suffix

  case $facts['os']['family'] {
    'RedHat': {
      if $facts['os']['release']['major'] =~ /^[789]$/ {
        $dist_version = $facts['os']['release']['major']
        $name_string  = "Enterprise Linux ${dist_version}"
      }

      # Fedora
      elsif $facts['os']['name'] == 'Fedora' {
        $dist_version  = $facts['os']['release']['full']
        $name_string   = "Fedora Core ${facts['os']['release']['full']}"
      }

      # newer Amazon Linux releases
      elsif ($facts['os']['name'] == 'Amazon') {
        $dist_version = '7'
        $name_string  = 'Enterprise Linux 7'
      }

      else {
        fail("Could not determine NodeSource repository URL for operatingsystem: ${facts['os']['name']} operatingsystemrelease: ${facts['os']['release']['full']}.")
      }

      $dist_type = $facts['os']['name'] ? {
        'Fedora' => 'fc',
        default  => 'el',
      }

      # nodesource repo
      $descr   = "Node.js Packages for ${name_string} - \$basearch"
      $baseurl = "https://rpm.nodesource.com/pub_${url_suffix}/${dist_type}/${dist_version}/\$basearch"

      # nodesource-source repo
      $source_descr   = "Node.js for ${name_string} - \$basearch - Source"
      $source_baseurl = "https://rpm.nodesource.com/pub_${url_suffix}/${dist_type}/${dist_version}/SRPMS"

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
