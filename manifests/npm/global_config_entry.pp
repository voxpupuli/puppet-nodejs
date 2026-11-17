# See README.md for usage information.
define nodejs::npm::global_config_entry (
  Enum['present', 'absent'] $ensure = 'present',
  String[1] $config_setting = $title,
  Optional[Variant[Boolean, Numeric, String[1]]] $value = undef,
  Optional[Stdlib::Absolutepath] $config_path = undef,
  Boolean $show_diff = false,
) {
  if $facts['os']['family'] == 'windows' {
    fail("${module_name}::npm::global_config_entry is not supported on Windows")
  }

  include nodejs

  if $ensure == 'present' and $value == undef {
    fail("${module_name}::npm::global_config_entry[${title}]: 'value' is required when 'ensure' is set to 'present'")
  }

  if $ensure == 'absent' and $value != undef {
    fail("${module_name}::npm::global_config_entry[${title}]: 'value' must not be set when 'ensure' is set to 'absent'")
  }

  # npm keeps its global configuration in `<prefix>/etc/npmrc`, where <prefix>
  # is the parent of the directory that holds the npm binary. The fact is
  # authoritative (the path can be moved with the globalconfig setting or the
  # NPM_CONFIG_GLOBALCONFIG environment variable), but it is not available when
  # npm is installed by the very catalog that sets the entry, so derive a
  # fallback from the configured binary.
  $npm_binary = regsubst($nodejs::npm_path, '^"(.*)"$', '\1')
  $fallback_config_path = "${dirname(dirname($npm_binary))}/etc/npmrc"
  $resolved_config_path = pick($config_path, $facts['npm_globalconfig_path'], $fallback_config_path)

  # A relative npm_path, such as a bare 'npm', would derive a relative path
  # from the working directory of the agent.
  if $resolved_config_path !~ /^\// {
    fail("${module_name}::npm::global_config_entry[${title}]: '${resolved_config_path}' is not an absolute path, set config_path")
  }

  $config_dir = dirname($resolved_config_path)

  if $resolved_config_path == "${facts['root_home']}/.npmrc" {
    fail("${module_name}::npm::global_config_entry[${title}]: ${resolved_config_path} is managed by nodejs::install (npmrc_config), use nodejs::npmrc_config instead")
  }

  if $ensure == 'present' {
    # ini_setting cannot create a missing parent directory, and on a fresh
    # node `<prefix>/etc` does not exist yet (e.g. /usr/etc for the
    # distribution packages). Create it only when missing: an existing
    # directory such as /etc or /root is never touched, so its owner and mode
    # stay as they are.
    # Several entries share one directory, so declare the exec idempotently.
    ensure_resource('exec', "nodejs npm global_config_entry mkdir ${config_dir}", {
      'command' => ['mkdir', '-p', $config_dir],
      'creates' => $config_dir,
      'path'    => ['/bin', '/usr/bin'],
      'require' => Class['nodejs'],
    })

    $ini_require = [Class['nodejs'], Exec["nodejs npm global_config_entry mkdir ${config_dir}"]]
  } else {
    $ini_require = [Class['nodejs']]
  }

  ini_setting { "nodejs npm global_config_entry ${title}":
    ensure    => $ensure,
    path      => $resolved_config_path,
    setting   => $config_setting,
    value     => $value,
    show_diff => $show_diff,
    require   => $ini_require,
  }
}
