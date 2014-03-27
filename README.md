# puppet-nodejs module

## Overview

Install nodejs package and npm package provider for Debian, Ubuntu, Fedora, and RedHat.

## Usage

### class nodejs

Installs nodejs and npm per [nodejs documentation](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager).

* dev_package: whether to install optional dev packages. dev packages not available on all platforms, default: false.

Example:

```puppet
include nodejs
```

You may want to use apt::pin to pin package installation priority on sqeeze. See [puppetlabs-apt](https://github.com/puppetlabs/puppetlabs-apt) for more information.

```puppet
apt::pin { 'sid': priority => 100 }
```

### npm Package Installation

Both global and local package installations are supported.

For more information regarding global vs. local installation see [nodejs blog](http://blog.nodejs.org/2011/03/23/npm-1-0-global-vs-local-installation/)


#### Global Packages

npm global packages are supported via the ruby provider **npm**.

The **npm** provider is an extension of the [Puppet Package Type](http://docs.puppetlabs.com/references/latest/type.html#package) and supports versionable and upgradeable features.

#### Using Code

```puppet
package { 'express':
  ensure   => present,
  provider => 'npm',
}

package { 'mime':
  ensure   => '1.2.4',
  provider => 'npm',
}
```

#### Using Hiera

Hiera may also be used to manage global npm packages.
The **npm** package provider will be used in conjunction with the hiera metadata to perform the installation.

- Global packages are expressed using the `global` hash under the `nodejs::npms` hash.
- Packages which accept all defaults should use an empty hash `{}` as the value.
- Default overrides and/or additional package installation arguments may be used: see the [Puppet Package Type](http://docs.puppetlabs.com/references/latest/type.html#package) for supported arguments.

Package Default Arguments:

```yaml
ensure   : 'present'
provider : 'npm'
```

The following example Hiera YAML configuration will:

- install the **express** package globally using defaults
- install the **mime** package globally using **version 1.2.4**

```yaml
nodejs::npms:
    global:
        express: {}
        mime:
            ensure: '1.2.4'
```

#### Local Packages

npm local packages are supported via the puppet defined type `nodejs::npm`

The `nodejs::npm` title consists of filepath and package name seperate via ':', and support the following attributes:

| Parameter   | Type    | Default | Required | Description |
| :-----------| :------ |:------- | :------: | :---------- |
| ensure      | string  | present | YES      | package present or absent |
| version     | string  | NONE    | NO       | package version |
| source      | string  | NONE    | NO       | package source |
| install_opt | string  | NONE    | NO       | option flags invoked during installation such as --link |
| remove_opt  | string  | NONE    | NO       | option flags invoked during removal |

#### Using Code

```puppet
nodejs::npm { '/opt/razor:express':
  ensure  => present,
  version => '2.5.9',
}
```

#### Using Hiera

Hiera may also be used to manage local npm packages.
The `nodejs::npm` defined type will be used in conjunction with the hiera metadata to perform the installation.

- Local packages are expressed using the `local` hash under the `nodejs::npms` hash.
- Packages which accept all defaults should use an empty hash `{}` as the value.
- Default overrides and/or additional package installation arguments supported by the `nodejs::npm` defined type may be used.

Package Default Arguments:

```yaml
ensure : 'present'
```

The following example Hiera YAML configuration will:

- install the **express** package **version 2.5.9** using **/opt/razor** as the current working directory

```yaml
nodejs::npms:
    local:
        '/opt/razor:express':
            version: '2.5.9'
```


## Supported Platforms

The module have been tested on the following operating systems. Testing and patches for other platforms are welcomed.

* Debian Wheezy.
* RedHat EL5.
