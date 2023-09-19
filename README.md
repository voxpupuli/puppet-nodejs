# Node.js module for Puppet

[![Build Status](https://travis-ci.org/voxpupuli/puppet-nodejs.png?branch=master)](https://travis-ci.org/voxpupuli/puppet-nodejs)
[![Code Coverage](https://coveralls.io/repos/github/voxpupuli/puppet-nodejs/badge.svg?branch=master)](https://coveralls.io/github/voxpupuli/puppet-nodejs)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/nodejs.svg)](https://forge.puppetlabs.com/puppet/nodejs)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/nodejs.svg)](https://forge.puppetlabs.com/puppet/nodejs)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/nodejs.svg)](https://forge.puppetlabs.com/puppet/nodejs)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/nodejs.svg)](https://forge.puppetlabs.com/puppet/nodejs)

## Table of Contents

1. [Overview](#overview)
1. [Setup - The basics of getting started with nodejs](#setup)
    * [Beginning with nodejs - Installation](#beginning-with-nodejs)
1. [Usage](#usage)
1. [Npm packages](#npm-packages)
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

The default version installed is currently `12.x`.

If you wish to install a Node.js 13.x release from the NodeSource repository
rather than 12.x on Debian/RHEL platforms:

```puppet
class { 'nodejs':
  repo_url_suffix => '13.x',
}
```

See the `repo_url_suffix` parameter entry below for possible values.

## Usage

When a separate npm package exists (natively or via EPEL) the Node.js development
package also needs to be installed as it is a dependency for npm.

Install Node.js and npm using the native packages provided by the distribution:

```puppet
class { '::nodejs':
  manage_package_repo       => false,
  nodejs_dev_package_ensure => installed,
  npm_package_ensure        => installed,
}
```

Install Node.js and npm using the packages from EPEL:

```puppet
class { '::nodejs':
  nodejs_dev_package_ensure => installed,
  npm_package_ensure        => installed,
  repo_class                => 'epel',
}
```

### Upgrades

The parameter `nodejs_package_ensure` defaults to `installed`. Changing the
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

For more information regarding global vs local installation see the [nodejs blog](https://nodejs.org/en/blog/npm/npm-1-0-global-vs-local-installation/)

### npm global packages

The npm package provider is an extension of the Puppet package type which
supports versionable and upgradeable. The package provider only handles global
installation:

For example:

```puppet
package { 'express':
  ensure   => installed,
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
  `installed`.
* Install options and uninstall options are also supported, and need to be
  specified as an array.
* The user parameter is provided should you wish to run npm install or npm rm
  as a specific user.
* If you want to use a package.json supplied by a module to install dependencies
  (e.g. if you have a NodeJS server app), set the parameter use_package_json to true.
  The package name is then only used for the resource name. source parameter is ignored.

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

## Limitations

See [`metadata.json`](metadata.json) for supported operating systems.

### Module dependencies

This modules uses `puppetlabs-apt` for the management of the NodeSource
repository. If using an operating system of the Debian-based family, you will
need to ensure that `puppetlabs-apt` version 4.4.0 or above is installed.

If using CentOS/RHEL and you wish to install Node.js from EPEL rather
than from the NodeSource repository, you will need to ensure `puppet-epel` is
installed and is applied before this module.

If using Gentoo, you will need to ensure `gentoo-portage` is installed.

If using Windows, you will need to ensure that `puppetlabs-chocolatey` is
installed.

nodejs::npm has the ability to fetch npm packages from Git sources. If you
wish to use this functionality, Git needs to be installed and be in the
`PATH`.

## Development

See [CONTRIBUTING](CONTRIBUTING.md)
