# Define: nodejs::npm
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Usage:
#
define nodejs::npm (
  $ensure       = present,
  $version      = undef,
  $source       = undef,
  $install_opt  = undef,
  $remove_opt   = undef,
  $exec_as_user = undef
) {
  include nodejs

  $npm = split($name, ':')
  $npm_dir = $npm[0]
  $npm_pkg = $npm[1]

  if $source {
    $install_pkg = $source
  } elsif $version {
    $install_pkg = "${npm_pkg}@${version}"
  } else {
    $install_pkg = $npm_pkg
  }

  if $version {
    $validate = "${npm_dir}/node_modules/${npm_pkg}:${npm_pkg}@${version}"
  } else {
    $validate = "${npm_dir}/node_modules/${npm_pkg}"
  }

  # exec_as_user allows to install an npm package only for a certain user
  # exec environment depends on exec user
  if $exec_as_user == undef {
     # if exec user is undefined, exec environment should not be set, so the package will get installed globally
     $exec_env = undef
  } else {
    # if exec user is defined, exec environment depends on the operating system
    case $::operatingsystem {
      'Debian','Ubuntu','RedHat','SLEL','Fedora','CentOS': {
        $exec_env = "HOME=/home/$exec_as_user"
      }
      default: {
       # so far only linux systems are supported with this option
       fail("unsupported operating system")
      }
    }     
  }

  if $ensure == present {
    exec { "npm_install_${name}":
      command     => "npm install ${install_opt} ${install_pkg}",
      unless      => "npm list -p -l | grep '${validate}'",
      cwd         => $npm_dir,
      path        => $::path,
      require     => Class['nodejs'],
      user        => $exec_as_user,
      environment => $exec_env,
    }

    # Conditionally require npm_proxy only if resource exists.
    Exec<| title=='npm_proxy' |> -> Exec["npm_install_${name}"]
  } else {
    exec { "npm_remove_${name}":
      command     => "npm remove ${npm_pkg}",
      onlyif      => "npm list -p -l | grep '${validate}'",
      cwd         => $npm_dir,
      path        => $::path,
      require     => Class['nodejs'],
      user        => $exec_as_user,
      environment => $exec_env,
    }
  }
}
