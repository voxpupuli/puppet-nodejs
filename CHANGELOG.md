##2015-01-21 - Release 0.7.1
###Summary

This fixes the incorrect application of https://github.com/puppetlabs/puppetlabs-nodejs/pull/70 so that the code will actually run.

##2015-01-20 - Release 0.7.0
###Summary

This release adds some new features and improvements, including archlinux support and improved ubuntu support.

####Features
- Add max_nesting parameter to npm list json parse
- Replace Chris's PPA with the Nodesource repo
- Parameterize package names
- Add archlinux support
- TravisCI updates

####Bugfixes
- Fix proxy config requiers for Ubunutu
- Fix rspec tests
- Fix typo in README.md

##2014-07-15 - Release 0.6.1
###Summary

This release merely updates metadata.json so the module can be uninstalled and
upgraded via the puppet module command.

##2014-06-18 - Release 0.6.0
###Summary

This release primarily has improved support for Gentoo and testing
improvements.

####Features
- Improved Gentoo support.
- Test updates

##2014-03-20 - Release 0.5.0
###Summary

This release is just a wrap up of a number of submitted PRs, mostly around
improvements to operating system support, as well as some improvements to
handling npm.

####Features
- Update travis to test more recent versions of Puppet.
- Changed package name for Amazon Linux.
- Add support for Scientific Linux.

####Bugfixes
- Ubuntu uses uppercase for the operatingsystem fact.
- Ignore exit codes from "npm list --json" as they can be misleading, and instead just parse the JSON.
- Set $HOME for npm commands.
- Don't include development version accidently.
- Fix for chrislea ppa that already installs npm.

##2013-08-29 - Release 0.4.0
###Summary

This release removes the precise special handling
and adds the ability to pass in $version.

####Features
 - Precise uses the same ppa as every other release.
 - New parameters in nodejs:
  - `version`: Set the version to install.

##2013-08-01 - Release 0.3.0
###Summary

The focus of this release is ensuring the module
still works on newer distributions.

####Features
- New parameters in nodejs:
 - `manage_repo`: Enable/Disable repo management.

####Bugfixes
- Fixed npm on Ubuntuwhen using Chris Lea's PPA
- Make RHEL6 variants the default.
- Fix yumrepo file ordering.

##0.2.1 2012-12-28 Puppet Labs <info@puppetlabs.com>
* Updated EL RPM repositories

##0.2.0 2012-05-22 Puppet Labs <info@puppetlabs.com>
* Add RedHat family support
* Use npm package instead of exec script.
* Remove ppa repo for Ubuntu Precise.

##0.1.1 2012-05-04 Puppet Labs <info@puppetlabs.com>
* Use include for apt class and add spec tests.

##0.1.0 2012-04-30 Puppet Labs <info@puppetlabs.com>
* Initial module release.
