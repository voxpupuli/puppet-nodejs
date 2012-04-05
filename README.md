# puppet-nodejs module

## Overview

Install nodejs package and npm package provider for Debian.

## Usage

### class nodejs

Installs nodejs via sid repo per [nodejs documentation](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager) and npm via the bash script per [npm documentation](https://github.com/isaacs/npm).

Example:

    include nodejs

You may want to use apt::pin to pin package installation priority. See [puppet-apt](https://github.com/puppetlabs/puppet-apt) for more information.

    apt::pin { 'sid': priority => 100 }

### npm package

npm package provider is an extension of puppet package type which supports versionable and upgradeable.

Example:

    package { 'express':
      ensure   => latest,
      provider => 'npm',
    }
    
    package { 'mime':
      ensure   => '1.2.4',
      provider => 'npm',
    }

## Supported Platforms

The module have been tested on the following operating systems. Testing and patches for other platforms are welcomed.

* Debian Wheezy
