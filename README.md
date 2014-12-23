# puppet-nodejs module

## Overview

Install nodejs package and npm package provider for Debian, Ubuntu, Fedora, RedHat, Gentoo and Archlinux.

## Usage

### class nodejs

Installs nodejs and npm per [nodejs documentation](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager).

* node_pkg: the package to install that provides nodejs.
* npm_pkg: the package to install that provides `npm`.
* dev_pkg: the package to install that provides the nodejs development libraries.
* dev_package: whether to install optional dev packages. dev packages not available on all platforms, default: false.
* manage_repo: whether to manage the repository that provides the packages for nodejs. Defaults to "false".
* proxy: the HTTP proxy to use for nodejs.
* version: the version of nodejs packages to install. Defaults to "present".

Examples:

    include nodejs

Red Hat Enterprise Linux (and derivatives) may want to install nodejs from Software Collections:

    class { 'nodejs':
      node_pkg    => 'nodejs010',
      npm_pkg     => 'nodejs010-npm',
      dev_pkg     => 'nodejs010-devel',
      dev_package => true,
    }

Debian users may want to use apt::pin to pin package installation priority on squeeze. See [puppetlabs-apt](https://github.com/puppetlabs/puppetlabs-apt) for more information.

    apt::pin { 'sid': priority => 100 }

### npm package

Two types of npm packages are supported.

* npm global packages are supported via ruby provider for puppet package type.
* npm local packages are supported via puppet define type nodejs::npm.

For more information regarding global vs. local installation see [nodejs blog](http://blog.nodejs.org/2011/03/23/npm-1-0-global-vs-local-installation/)

### package
npm package provider is an extension of puppet package type which supports versionable and upgradeable. The package provider only handles global installation:

Example:

    package { 'express':
      ensure   => present,
      provider => 'npm',
    }
    
    package { 'mime':
      ensure   => '1.2.4',
      provider => 'npm',
    }

### nodejs::npm
nodejs::npm is suitable for local installation of npm packages:

    nodejs::npm { '/opt/razor:express':
      ensure  => present,
      version => '2.5.9',
    }

nodejs::npm title consists of filepath and package name seperate via ':', and support the following attributes:

* ensure: present, absent.
* version: package version (optional).
* source: package source (optional).
* install_opt: option flags invoked during installation such as --link (optional).
* remove_opt: option flags invoked during removal (optional).

## Supported Platforms

The module have been tested on the following operating systems. Testing and patches for other platforms are welcomed.

* Debian Wheezy
* Red Hat Enterprise Linux 5
* Red Hat Enterprise Linux 6
