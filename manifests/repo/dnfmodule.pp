# @summary Manage the DNF module
#
# On EL8+ DNF can manage modules.
# This is a method of providing multiple versions on the same OS.
# Only one DNF module stream can be active at the same time.
#
# @param ensure
#   Value of ensure parameter for nodejs dnf module package
#
# @param module
#   Name of the nodejs dnf package
#
# @api private
class nodejs::repo::dnfmodule (
  String[1] $ensure = $nodejs::repo_version,
  String[1] $module = 'nodejs',
) {
  package { 'nodejs dnf module':
    ensure      => $ensure,
    name        => $module,
    enable_only => true,
    provider    => 'dnfmodule',
  }
}
