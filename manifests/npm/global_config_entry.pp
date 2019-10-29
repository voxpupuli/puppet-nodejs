# See README.md for usage information.
define nodejs::npm::global_config_entry (
  Enum['present', 'absent'] $ensure = 'present',
  $config_setting                   = $title,
  $cmd_exe_path                     = $nodejs::cmd_exe_path,
  $npm_path                         = $nodejs::params::npm_path,
  $value                            = undef,
) {

  include nodejs

  case $ensure {
    'absent': {
      $command = "config delete ${config_setting} --global"

      # If this is a secret key, determine if it is set properly outside of NPM
      # https://github.com/voxpupuli/puppet-nodejs/issues/326
      if $config_setting =~ /(_|:_)/ {
        $onlyif_command = $facts['os']['family'] ? {
          'Windows' => "${cmd_exe_path} /C FOR /F %G IN ('${npm_path} config get globalconfig') DO IF EXIST %G (FINDSTR /B /C:\"${$config_setting}\" %G) ELSE (EXIT 1)",
          default   => "test -f $(${npm_path} config get globalconfig) && /bin/grep -qe \"^${$config_setting}\" $(${npm_path} config get globalconfig)",
        }
      }
      else {
        $onlyif_command = $facts['os']['family'] ? {
          'Windows' => "${cmd_exe_path} /C ${npm_path} get --global| FINDSTR /B \"${config_setting}\"",
          default   => "${npm_path} get --global | /bin/grep -e \"^${config_setting}\"",
        }
      }
    }
    default: {
      $command = "config set ${config_setting} ${value} --global"

      # If this is a secret key, determine if it is set properly outside of NPM
      # https://github.com/voxpupuli/puppet-nodejs/issues/326
      if $config_setting =~ /(_|:_)/ {
        $onlyif_command = $facts['os']['family'] ? {
          'Windows' => "${cmd_exe_path} /V /C FOR /F %G IN ('${npm_path} config get globalconfig') DO IF EXIST %G (FINDSTR /B /C:\"${$config_setting}=\\\"${$value}\\\"\" %G & IF !ERRORLEVEL! EQU 0 ( EXIT 1 ) ELSE ( EXIT 0 )) ELSE ( EXIT 0 )",
          default   => "! test -f $(${npm_path} config get globalconfig) || ! /bin/grep -qe '^${$config_setting}=\"\\?${$value}\"\\?$' $(${npm_path} config get globalconfig)",
        }
      }
      else {
        $onlyif_command = $facts['os']['family'] ? {
          'Windows' => "${cmd_exe_path} /C FOR /F %i IN ('${npm_path} get ${config_setting} --global') DO IF \"%i\" NEQ \"${value}\" ( EXIT 0 ) ELSE ( EXIT 1 )",
          default   => "/usr/bin/test \"$(${npm_path} get ${config_setting} --global | /usr/bin/tr -d '\n')\" != \"${value}\"",
        }
      }
    }
  }

  if $nodejs::npm_package_ensure != 'absent' {
    $exec_require = "Package[${nodejs::npm_package_name}]"
  } elsif $nodejs::repo_class == '::nodejs::repo::nodesource' {
    $exec_require = "Package[${nodejs::nodejs_package_name}]"
  } else {
    $exec_require = undef
  }

  #Determine exec provider
  $provider = $facts['os']['family'] ? {
    'Windows' => 'windows',
    default   => 'shell',
  }

  exec { "npm_config ${ensure} ${title}":
    command  => "${npm_path} ${command}",
    provider => $provider,
    onlyif   => $onlyif_command,
    require  => $exec_require,
  }
}
