# == Class: nodejs: See README.md for documentation.
class nodejs(
  $cmd_exe_path                                        = $nodejs::params::cmd_exe_path,
  Boolean $manage_package_repo                         = $nodejs::params::manage_package_repo,
  $nodejs_debug_package_ensure                         = $nodejs::params::nodejs_debug_package_ensure,
  Optional[String] $nodejs_debug_package_name          = $nodejs::params::nodejs_debug_package_name,
  $nodejs_dev_package_ensure                           = $nodejs::params::nodejs_dev_package_ensure,
  Optional[String] $nodejs_dev_package_name            = $nodejs::params::nodejs_dev_package_name,
  $nodejs_package_ensure                               = $nodejs::params::nodejs_package_ensure,
  $nodejs_package_name                                 = $nodejs::params::nodejs_package_name,
  $npm_package_ensure                                  = $nodejs::params::npm_package_ensure,
  Optional[Variant[Boolean, String]] $npm_package_name = $nodejs::params::npm_package_name,
  $npm_path                                            = $nodejs::params::npm_path,
  Optional[String] $npmrc_auth                         = $nodejs::params::npmrc_auth,
  Optional[Hash] $npmrc_config                         = $nodejs::params::npmrc_config,
  $repo_class                                          = $nodejs::params::repo_class,
  $repo_enable_src                                     = $nodejs::params::repo_enable_src,
  $repo_ensure                                         = $nodejs::params::repo_ensure,
  $repo_pin                                            = $nodejs::params::repo_pin,
  $repo_priority                                       = $nodejs::params::repo_priority,
  $repo_proxy                                          = $nodejs::params::repo_proxy,
  $repo_proxy_password                                 = $nodejs::params::repo_proxy_password,
  $repo_proxy_username                                 = $nodejs::params::repo_proxy_username,
  Optional[String] $repo_release                       = $nodejs::params::repo_release,
  $repo_url_suffix                                     = $nodejs::params::repo_url_suffix,
  Array $use_flags                                     = $nodejs::params::use_flags,
  Optional[String] $package_provider                   = $nodejs::params::package_provider,
) inherits nodejs::params {

  if $manage_package_repo and !$repo_class {
    fail("${module_name}: The manage_package_repo parameter was set to true but no repo_class was provided.")
  }

  contain '::nodejs::install'

  if $manage_package_repo {
    include $repo_class

    Class[$repo_class]
    -> Class['::nodejs::install']
  }
}
