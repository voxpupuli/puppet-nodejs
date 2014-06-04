# puppet-nodejs module

## Overview

Install nodejs package and npm package provider for Debian, Ubuntu, Fedora, and RedHat.

## Usage

### class nodejs

Installs nodejs and npm per [nodejs documentation](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager).

* dev_package: whether to install optional dev packages. dev packages not available on all platforms, default: false.
* install_npm_package: whether to install npm package, default: true
* node_package_name: name of nodejs package to install, default: nodejs
* npm_package_name: name of npm package to install, default: npm

Recognize OS and install node and npm packages:

```puppet
include nodejs
```

To ignore npm package:

```puppet
class { '::nodejs':
  install_npm_package => false
}
```
Change name of npm and/or node package:

```puppet
class { '::nodejs':
  node_package_name => 'nodejs-0.8.15',
  npm_package_name  => 'npm-1.1'
}
```

You may want to use apt::pin to pin package installation priority on sqeeze. See [puppetlabs-apt](https://github.com/puppetlabs/puppetlabs-apt) for more information.

```puppet
apt::pin { 'sid': priority => 100 }
```

### npm package

Two types of npm packages are supported.

* npm global packages are supported via ruby provider for puppet package type.
* npm local packages are supported via puppet define type nodejs::npm.

For more information regarding global vs. local installation see [nodejs blog](http://blog.nodejs.org/2011/03/23/npm-1-0-global-vs-local-installation/)

### package
npm package provider is an extension of puppet package type which supports versionable and upgradeable. The package provider only handles global installation:

Example:

```puppet
package { 'express':
  ensure   => present,
  provider => 'npm',
}
```

```puppet
package { 'mime':
  ensure   => '1.2.4',
  provider => 'npm',
}
```

### nodejs::npm
nodejs::npm is suitable for local installation of npm packages:

```puppet
nodejs::npm { '/opt/razor:express':
  ensure  => present,
  version => '2.5.9',
}
```

nodejs::npm title consists of filepath and package name seperate via ':', and support the following attributes:

* ensure: present, absent.
* version: package version (optional).
* source: package source (optional).
* install_opt: option flags invoked during installation such as --link (optional).
* remove_opt: option flags invoked during removal (optional).

## Supported Platforms

The module have been tested on the following operating systems. Testing and patches for other platforms are welcomed.

* Debian Wheezy.
* RedHat EL5.
* Ubuntu
* SLES
* Scientific
* CentOS
* OEL
* OracleLinux
