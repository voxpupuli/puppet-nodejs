# See README.md for usage information.
define nodejs::npm::global_config_entry (
  Enum['present', 'absent'] $ensure = 'present',
  String[1] $config_setting         = $title,
  Optional[String[1]] $value        = undef,
) {
  ini_setting { $title:
    ensure  => $ensure,
    path    => $facts['npm_globalconfig_path'],
    setting => $config_setting,
    value   => $value,
  }
}
