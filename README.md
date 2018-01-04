# Node.js module for Puppet

[![Build Status](https://travis-ci.org/voxpupuli/puppet-nodejs.png?branch=master)](https://travis-ci.org/voxpupuli/puppet-nodejs)
[![Code Coverage](https://coveralls.io/repos/github/voxpupuli/puppet-nodejs/badge.svg?branch=master)](https://coveralls.io/github/voxpupuli/puppet-nodejs)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/nodejs.svg)](https://forge.puppetlabs.com/puppet/nodejs)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/nodejs.svg)](https://forge.puppetlabs.com/puppet/nodejs)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/nodejs.svg)](https://forge.puppetlabs.com/puppet/nodejs)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/nodejs.svg)](https://forge.puppetlabs.com/puppet/nodejs)

#### Table of Contents

1. [Overview](#overview)
1. [Setup - The basics of getting started with nodejs](#setup)
    * [Beginning with nodejs - Installation](#beginning-with-nodejs)
1. [Usage](#usage)
1. [Npm packages](#npm-packages)
1. [Parameters](#parameters)
1. [Limitations - OS compatibility, etc.](#limitations)
    * [Module dependencies](#module-dependencies)
1. [Development](#development)

## Overview

The nodejs module installs the Node.js package, (global) npm package provider
and configures global npm configuration settings. A defined type nodejs::npm
is used for the local installation of npm packages.

By default this module installs packages from the [NodeSource](https://nodesource.com)
repository on Debian and RedHat platforms. The NodeSource Node.js package
includes the npm binary, which makes a separate npm package unnecessary.

On SUSE, ArchLinux, FreeBSD, OpenBSD and Gentoo, native packages are used. On
Darwin, the MacPorts package is used. On Windows the packages are installed
via Chocolatey.

## Setup

### What nodejs affects

* the Node.js package
* the npm package (if it exists as a separate package)
* the global npmrc file ($PREFIX/etc/npmrc)
* globally installed npm packages
* local npm packages installed in user-specified directories

### Beginning with nodejs

To install Node.js and npm (using the NodeSource repository if possible):

```puppet
class { 'nodejs': }
```

If you wish to install a Node.js 0.12.x release from the NodeSource repository
rather than 0.10.x on Debian/RH platforms:

```puppet
class { 'nodejs':
  repo_url_suffix => '0.12',
}
```

Or if you wish to install a Node.js 5.x release from the NodeSource repository:
(4.x. is left as a exercise for the reader)

```puppet
class { 'nodejs':
  repo_url_suffix => '5.x',
}
```

## Usage

When a separate npm package exists (natively or via EPEL) the Node.js development
package also needs to be installed as it is a dependency for npm.

Install Node.js and npm using the native packages provided by the distribution:

```puppet
class { '::nodejs':
  manage_package_repo       => false,
  nodejs_dev_package_ensure => 'present',
  npm_package_ensure        => 'present',
}
```

Install Node.js and npm using the packages from EPEL:

```puppet
class { '::nodejs':
  nodejs_dev_package_ensure => 'present',
  npm_package_ensure        => 'present',
  repo_class                => '::epel',
}
```

### Upgrades

The parameter `nodejs_package_ensure` defaults to `present`. Changing the
`repo_url_suffix` will not result in a new version being installed. Changing
the `nodejs_package_ensure` parameter should provide the desired effect.

For example:

```puppet
# Upgrade from nodejs 5.x to 6.x
class { 'nodejs':
    repo_url_suffix       => '6.x',
    nodejs_package_ensure => '6.12.2',
  }
```

### Forcing the installation of NodeSource packages over native packages

When the native package version and NodeSource version are the same, you may
need to use `repo_pin` or `repo_priority` (depending on your operating system).
This ensures that the version in the NodeSource repository takes precedence
when Puppet invokes Apt/Yum.

### npm packages

Two types of npm packages are supported:

* npm global packages are supported via the `npm` provider for the puppet
  package type.
* npm local packages are supported via the Puppet defined type nodejs::npm.

For more information regarding global vs local installation see the [nodejs blog](http://blog.nodejs.org/2011/03/23/npm-1-0-global-vs-local-installation/)

### npm global packages

The npm package provider is an extension of the Puppet package type which
supports versionable and upgradeable. The package provider only handles global
installation:

For example:

```puppet
package { 'express':
  ensure   => 'present',
  provider => 'npm',
}

package { 'mime':
  ensure   => '1.2.4',
  provider => 'npm',
}
```

### npm local packages

nodejs::npm is used for the local installation of npm packages. It attempts to
support all of the `npm install <package>` combinations shown in the
[npm install docs](https://docs.npmjs.com/cli/install)
except version ranges. The title simply must be a unique, arbitrary value.

* If using packages directly off the npm registry, the package parameter is the
  name of the package as published on the npm registry.
* If using scopes, the package parameter needs to be specified as
  '@scope_name/package_name'.
* If using a local tarball path, remote tarball URL, local folder, git remote
  URL or GitHubUser/GitRepo as the source of the package, this location needs
  to be specified as the source parameter and the package parameter just needs
  to be a unique, descriptive name for the package that is being installed.
* If using tags, the tag can be specified with the ensure parameter, and
  the package parameter needs to be match the name of the package in the npm
  registry.
* Package versions are specified with the ensure parameter, which defaults to
  `present`.
* Install options and uninstall options are also supported, and need to be
  specified as an array.
* The user parameter is provided should you wish to run npm install or npm rm
  as a specific user.
* If you want to use a package.json supplied by a module to install dependencies
  (e.g. if you have a NodeJS server app), set the parameter use_package_json to true.
  The package name is then only used for the resource name. source parameter is ignored.

nodejs::npm parameters:

* ensure: present (default), absent, latest, tag or version number.
* source: package source (defaults to a reserved value 'registry')
* target: where to install the package
* install_options: option flags invoked during installation such as --link (optional).
* uninstall_options: option flags invoked during removal (optional).
* npm_path: defaults to the value listed in `nodejs::params`
* user: defaults to undef
* use_package_json: read and install modules listed in package.json in target dir and install those in subdirectory node_modules (defaults to false)

Examples:

Install the express package published on the npm registry to /opt/packages:

```puppet
nodejs::npm { 'express from the npm registry':
  ensure  => 'present',
  package => 'express',
  target  => '/opt/packages',
}
```

or the lazy way:

```puppet
nodejs::npm { 'express':
  target  => '/opt/packages',
}
```

Install the express package as user foo:

```puppet
nodejs::npm { 'express install as user foo':
  ensure  => 'present',
  package => 'express',
  target  => '/opt/packages',
  user    => 'foo',
}
```

Install a specific version of express to /opt/packages:

```puppet
nodejs::npm { 'express version 2.5.9 from the npm registry':
  ensure  => '2.5.9',
  package => 'express',
  target  => '/opt/packages',
}
```

Install the latest version of express to /opt/packages:

```puppet
nodejs::npm { 'express latest from the npm registry':
  ensure  => 'latest',
  package => 'express',
  target  => '/opt/packages',
}
```

Install express from GitHub to /opt/packages:

```puppet
nodejs::npm { 'express from GitHub':
  ensure  => 'present',
  package => 'express',
  source  => 'strongloop/express',
  target  => '/opt/packages',
}
```

Install express from a remote git repository to /opt/packages:

```puppet
nodejs::npm { 'express from a git repository':
  ensure  => 'present',
  package => 'express',
  source  => 'git+https://git@github.com/strongloop/expressjs.git',
  target  => '/opt/packages',
}
```

Install express from a remote tarball to /opt/packages:

```puppet
nodejs::npm { 'express from a remote tarball':
  ensure  => 'present',
  package => 'express',
  source  => 'https://server.domain/express.tgz',
  target  => '/opt/packages',
}
```

Install tagged packages:

```puppet
nodejs::npm { 'my beta tagged package':
  ensure  => 'beta',
  package => 'mypackage',
  target  => '/opt/packages',
}
```

Install a package from the registry associated with a specific scope:

```puppet
nodejs::npm { 'package_name from @scope_name':
  ensure  => 'present',
  package => '@scope_name/package_name',
  target  => '/opt/packages',
}
```

Install express from a local tarball to /opt/packages:

```puppet
nodejs::npm { 'express from a local tarball':
  ensure  => 'present',
  package => 'express',
  source  => '/local/repository/npm_packages/express.tgz',
  target  => '/opt/packages',
}
```

Install express with --save-dev --no-bin-links passed to `npm install`:

```puppet
nodejs::npm { 'express with options':
  ensure          => 'present',
  package         => 'express',
  install_options => ['--save-dev', '--no-bin-links'],
  target          => '/opt/packages',
}
```

Install dependencies from package.json:

```puppet
nodejs::npm { 'serverapp':
  ensure           => 'present',
  target           => '/opt/serverapp',
  use_package_json => true,
}
```

Uninstall any versions of express in /opt/packages regardless of source:

```puppet
nodejs::npm { 'remove all express packages':
  ensure  => 'absent',
  package => 'express',
  target  => '/opt/packages',
}
```

Uninstall dependencies from package.json:

```puppet
nodejs::npm { 'serverapp':
  ensure           => 'absent',
  target           => '/opt/serverapp',
  use_package_json => true,
}
```

### nodejs::npm::global_config_entry

nodejs::npm::global_config_entry can be used to set/remove global npm
configuration settings.

Note that when specifying a URL, such as registry, NPM will add a trailing
slash when it stores the config. You must specify a trailing slash in your URL
or the code will not be idempotent.

Examples:

```puppet
nodejs::npm::global_config_entry { 'proxy':
  ensure => 'present',
  value  => 'http://proxy.company.com:8080/',
}
```

```puppet
nodejs::npm::global_config_entry { 'dev':
  ensure => 'present',
  value  => 'true',
}
```

Delete the key from all configuration files:

```puppet
nodejs::npm::global_config_entry { 'color':
  ensure => 'absent',
}
```

If a global_config_entry of `proxy` or `https-proxy` is specified, this will be
applied before the local installation of npm packages using `nodejs::npm`.

### Parameters

#### `cmd_exe_path`

Path to cmd.exe on Windows. Defaults to C:\Windows\system32\cmd.exe. You may
need to change this parameter for certain versions of Windows Server.

#### `manage_package_repo`

Whether to manage an external repository and use it as the source of the
Node.js and npm package. Defaults to `true`.

#### `nodejs_debug_package_ensure`

When set to `present` or a version number, determines whether to install the
Node.js package with debugging symbols, if available. Defaults to `absent`.

#### `nodejs_dev_package_ensure`

When set to `present` or a version number, determines whether to install the
development Node.js package, if available. Defaults to `absent`.

#### `nodejs_package_ensure`

When set to `present` or a version number, determines whether to install the
Node.js package. Defaults to `present`.

#### `npm_package_ensure`

When set to `present` or a version number, determines whether to install the
separate npm package. When using the NodeSource repository, the Node.js
package includes npm, so this value defaults to `absent`. This parameter will
need to be set to `present` if you wish to use the native packages or are
using the EPEL repository.

#### `npm_path`

Path to the npm binary.

#### `npmrc_auth`

A string that contains the value for the key `_auth` that will be set in
`/root/.npmrc`, as this value is not allowed to be set by
nodejs::npm::global_config_entry. The default value is `undef`.

#### `npmrc_config`

A hash that contains keys/values that will be set in `/root/.npmrc`,
in the form of `key=value`. Useful for setting a http-proxy for npm only.
The default value is `undef`.

#### `repo_class`

Name of the Puppet class used for the setup and management of the Node.js
repository. Defaults to `::nodejs::repo::nodesource` (NodeSource).
If using the Node.js and npm packages from the EPEL repository, set this to
`::epel` and make sure that the EPEL module is applied before the nodejs
module in your Puppet node definitions.

#### `repo_enable_src`

Whether any repositories which hold sources are enabled. Defaults to `false`.

#### `repo_ensure`

Whether to ensure that the repository exists, if it is being managed. Defaults
to `present` and may also be set to `absent`.

#### `repo_pin`

Whether to perform APT pinning to pin the Node.js repository with a specific
value. Defaults to `undef`.

#### `repo_priority`

Whether to set a Yum priority for the Node.js repository. If using EPEL and
the NodeSource repository on the same system, you may wish to set this to a
value less than 99 (or the priority set for the EPEL repository) to ensure
that the NodeSource repository will always be preferred over the Node.js
packages in EPEL, should they both hold the same Node.js version. Defaults to
`absent`.

#### `repo_proxy`

Whether to use a proxy for this particular repository. For example,
`http://proxy.domain`. Defaults to `absent`.

#### `repo_proxy_password`

Password for the proxy used by the repository, if required.

#### `repo_proxy_username`

User for the proxy used by the repository, if required.

#### `repo_release`

Optional value to override the apt distribution release.  Defaults to `undef`
which will autodetect the distribution. If a value is specified, this will
change the NodeSource apt repository distribution.
This is useful if the distribution name does not exist in the NodeSource
repositories. For example, the Ubilinux distribution release name 'dolcetto'
does not exist in NodeSource, but is a derivative of Debian 9 (Stretch).
Setting this value to `stretch` allows NodeSource repository management to
then work as expected on these systems.

#### `repo_url_suffix`

Defaults to ```0.10``` which means that the latest NodeSource 0.10.x release
is installed. If you wish to install a 0.12.x release or greater, you will
need to set this value accordingly. This parameter is a just a reflection of
the NodeSource URL structure - NodeSource might remove old versions (such as
0.10 and 0.12) or add new ones (such as 8.x) at any time.

The following are ``repo_url_suffix`` values that reflect NodeSource versions
that were available on 2017-11-29:

* Debian 8 (Jessie) ```0.10``` ```0.12``` ```4.x``` ```5.x``` ```6.x``` ```7.x``` ```8.x``` ```9.x```
* Debian 9 (Stretch) ```4.x``` ```6.x``` ```7.x``` ```8.x``` ```9.x```
* Debian (Sid) ```0.10``` ```0.12``` ```4.x``` ```5.x``` ```6.x``` ```7.x``` ```8.x``` ```9.x```
* Ubuntu 14.04 (Trusty) ```0.10``` ```0.12``` ```4.x``` ```5.x``` ```6.x``` ```7.x``` ```8.x``` ```9.x```
* Ubuntu 16.04 (Xenial) ```0.10``` ```0.12``` ```4.x``` ```5.x``` ```6.x``` ```7.x``` ```8.x``` ```9.x```
* Ubuntu 16.10 (Yakkety) ```0.12``` ```4.x``` ```6.x``` ```7.x``` ```8.x```
* Ubuntu 17.10 (Artful) ```4.x``` ```6.x``` ```8.x``` ```9.x```
* RHEL/CentOS 5 ```0.10``` ```0.12```
* RHEL/CentOS 6 ```0.10``` ```0.12``` ```4.x``` ```5.x``` ```6.x``` ```7.x``` ```8.x``` ```9.x```
* RHEL/CentOS 7 ```0.10``` ```0.12``` ```4.x``` ```5.x``` ```6.x``` ```7.x``` ```8.x``` ```9.x```
* Amazon Linux - See RHEL/CentOS 7
* Fedora 25 ```4.x``` ```6.x``` ```7.x``` ```8.x``` ```9.x```
* Fedora 26 ```6.x``` ```8.x``` ```9.x```
* Fedora 27 ```8.x``` ```9.x```

#### `use_flags`

The USE flags to use for the Node.js package on Gentoo systems. Defaults to
['npm', 'snapshot'].

#### `package_provider`

The package provider is set as the default for most distributions. You can override
this with the package_provider parameter to use an alternative

## Limitations

This module has received limited testing on:

* CentOS/RHEL 6/7
* Debian 8
* Ubuntu 14.04

The following platforms should also work, but have not been tested:

* Amazon Linux
* Archlinux
* Darwin
* Debian 9
* Fedora
* FreeBSD
* Gentoo
* OpenBSD
* OpenSuse/SLES
* Ubilinux
* Windows

### Module dependencies

This modules uses `puppetlabs-apt` for the management of the NodeSource
repository. If using an operating system of the Debian-based family, you will
need to ensure that `puppetlabs-apt` version 4.4.0 or above is installed.

If using CentOS/RHEL 6/7 and you wish to install Node.js from EPEL rather
than from the NodeSource repository, you will need to ensure `stahnma-epel` is
installed and is applied before this module.

If using Gentoo, you will need to ensure `gentoo-portage` is installed.

If using Windows, you will need to ensure that `chocolatey-chocolatey` is
installed.

nodejs::npm has the ability to fetch npm packages from Git sources. If you
wish to use this functionality, Git needs to be installed and be in the
`PATH`.

## Development

See [CONTRIBUTING](CONTRIBUTING.md)
