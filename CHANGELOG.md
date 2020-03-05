# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v8.0.0](https://github.com/voxpupuli/puppet-nodejs/tree/v8.0.0) (2020-03-10)

[Full Changelog](https://github.com/voxpupuli/puppet-nodejs/compare/v7.0.1...v8.0.0)

**Breaking changes:**

- update list of tested OSes accordingly with metadata.json [\#414](https://github.com/voxpupuli/puppet-nodejs/pull/414) ([mmoll](https://github.com/mmoll))
- drop Ubuntu 14.04 support [\#408](https://github.com/voxpupuli/puppet-nodejs/pull/408) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Add Debian 10 \(Buster\) support [\#400](https://github.com/voxpupuli/puppet-nodejs/issues/400)
- Add support for RHEL 8 based distros [\#413](https://github.com/voxpupuli/puppet-nodejs/pull/413) ([mmoll](https://github.com/mmoll))

**Fixed bugs:**

- Issues with puppet agent 6.8.0 [\#401](https://github.com/voxpupuli/puppet-nodejs/issues/401)
- Fix syntax error [\#407](https://github.com/voxpupuli/puppet-nodejs/pull/407) ([ghoneycutt](https://github.com/ghoneycutt))

**Merged pull requests:**

- delete legacy travis directory [\#411](https://github.com/voxpupuli/puppet-nodejs/pull/411) ([bastelfreak](https://github.com/bastelfreak))
- Remove duplicate CONTRIBUTING.md file [\#409](https://github.com/voxpupuli/puppet-nodejs/pull/409) ([dhoppe](https://github.com/dhoppe))
- Add Debian 10 support [\#406](https://github.com/voxpupuli/puppet-nodejs/pull/406) ([wiebe](https://github.com/wiebe))
- Fix global\_config\_entry dependency on NPM when using nodesource repo [\#405](https://github.com/voxpupuli/puppet-nodejs/pull/405) ([wiebe](https://github.com/wiebe))
- Clean up acceptance spec helper [\#403](https://github.com/voxpupuli/puppet-nodejs/pull/403) ([ekohl](https://github.com/ekohl))

## [v7.0.1](https://github.com/voxpupuli/puppet-nodejs/tree/v7.0.1) (2019-06-04)

[Full Changelog](https://github.com/voxpupuli/puppet-nodejs/compare/v7.0.0...v7.0.1)

**Fixed bugs:**

- Fix idempotence of unquoted secrets [\#390](https://github.com/voxpupuli/puppet-nodejs/pull/390) ([aboks](https://github.com/aboks))

**Merged pull requests:**

- Allow puppetlabs/stdlib 6.x [\#396](https://github.com/voxpupuli/puppet-nodejs/pull/396) ([dhoppe](https://github.com/dhoppe))

## [v7.0.0](https://github.com/voxpupuli/puppet-nodejs/tree/v7.0.0) (2019-02-02)

[Full Changelog](https://github.com/voxpupuli/puppet-nodejs/compare/v6.0.0...v7.0.0)

**Breaking changes:**

- modulesync 2.5.1 and drop Puppet 4 [\#387](https://github.com/voxpupuli/puppet-nodejs/pull/387) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- Poor idempotency for NPM "secret" keys [\#326](https://github.com/voxpupuli/puppet-nodejs/issues/326)
- Ensure NPM secret keys are idempotent in global\_config\_entry [\#386](https://github.com/voxpupuli/puppet-nodejs/pull/386) ([jplindquist](https://github.com/jplindquist))

**Closed issues:**

- test error when running locally [\#312](https://github.com/voxpupuli/puppet-nodejs/issues/312)

**Merged pull requests:**

- Fix broken unit tests [\#389](https://github.com/voxpupuli/puppet-nodejs/pull/389) ([jplindquist](https://github.com/jplindquist))
- modulesync 2.2.0 and allow puppet 6.x [\#380](https://github.com/voxpupuli/puppet-nodejs/pull/380) ([bastelfreak](https://github.com/bastelfreak))

## [v6.0.0](https://github.com/voxpupuli/puppet-nodejs/tree/v6.0.0) (2018-09-07)

[Full Changelog](https://github.com/voxpupuli/puppet-nodejs/compare/v5.0.0...v6.0.0)

**Breaking changes:**

- Default to a newer Nodejs version \(8.x\) [\#356](https://github.com/voxpupuli/puppet-nodejs/issues/356)
- Allow puppetlabs/stdlib 5.x, replace chocolatey-chocolatey with puppetlabs-chocolatey [\#378](https://github.com/voxpupuli/puppet-nodejs/pull/378) ([bastelfreak](https://github.com/bastelfreak))
- Set default version to 8.x [\#357](https://github.com/voxpupuli/puppet-nodejs/pull/357) ([juniorsysadmin](https://github.com/juniorsysadmin))

**Implemented enhancements:**

- Ubuntu 18.04 gives warning [\#361](https://github.com/voxpupuli/puppet-nodejs/issues/361)
- Add support for ubuntu bionic 18.04, \#361 [\#362](https://github.com/voxpupuli/puppet-nodejs/pull/362) ([fnoop](https://github.com/fnoop))

**Fixed bugs:**

- Wrong repository entry created in Debian stretch [\#355](https://github.com/voxpupuli/puppet-nodejs/issues/355)
- fix 'nodejs::repo\_ensure: absent' for yum [\#373](https://github.com/voxpupuli/puppet-nodejs/pull/373) ([bugfood](https://github.com/bugfood))
-  block creation of File\['root\_npmrc'\] when running on Windows [\#364](https://github.com/voxpupuli/puppet-nodejs/pull/364) ([jhicks-camgian](https://github.com/jhicks-camgian))

**Closed issues:**

- Fedora support [\#371](https://github.com/voxpupuli/puppet-nodejs/issues/371)
- Ubutnu 16.04 second provisioning fails & puts node.js in invalid state [\#360](https://github.com/voxpupuli/puppet-nodejs/issues/360)
- Installing Angular-CLI happens on every run [\#314](https://github.com/voxpupuli/puppet-nodejs/issues/314)

**Merged pull requests:**

- drop EOL OSs; fix puppet version range [\#370](https://github.com/voxpupuli/puppet-nodejs/pull/370) ([bastelfreak](https://github.com/bastelfreak))
- rename default\_module\_facts.{yaml,yml} [\#368](https://github.com/voxpupuli/puppet-nodejs/pull/368) ([bastelfreak](https://github.com/bastelfreak))
- Rely on beaker-hostgenerator for docker nodesets [\#367](https://github.com/voxpupuli/puppet-nodejs/pull/367) ([ekohl](https://github.com/ekohl))

## [v5.0.0](https://github.com/voxpupuli/puppet-nodejs/tree/v5.0.0) (2018-01-04)

[Full Changelog](https://github.com/voxpupuli/puppet-nodejs/compare/v4.0.1...v5.0.0)

**Breaking changes:**

- Use puppetlabs-apt to handle apt-transport-https [\#348](https://github.com/voxpupuli/puppet-nodejs/pull/348) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Remove legacy\_debian\_symlinks parameter [\#347](https://github.com/voxpupuli/puppet-nodejs/pull/347) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Remove EOL operating systems, Legacy facts. [\#343](https://github.com/voxpupuli/puppet-nodejs/pull/343) ([juniorsysadmin](https://github.com/juniorsysadmin))

**Implemented enhancements:**

- Rely on puppetlabs-apt 4.4.0 for apt-transport-https installation [\#345](https://github.com/voxpupuli/puppet-nodejs/issues/345)
- Refresh params.pp [\#336](https://github.com/voxpupuli/puppet-nodejs/issues/336)
- Provide option to install node using Brew [\#236](https://github.com/voxpupuli/puppet-nodejs/issues/236)
- Add repo\_release parameter [\#349](https://github.com/voxpupuli/puppet-nodejs/pull/349) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Allow for the macports provider to be overridden on macos [\#321](https://github.com/voxpupuli/puppet-nodejs/pull/321) ([kizzie](https://github.com/kizzie))

**Fixed bugs:**

- Circular symlinks when legacy\_debian\_symlinks = true [\#335](https://github.com/voxpupuli/puppet-nodejs/issues/335)

**Closed issues:**

- Handling os and family facts issue [\#344](https://github.com/voxpupuli/puppet-nodejs/issues/344)
- Docs: Add info important for upgrades, repository priorities [\#322](https://github.com/voxpupuli/puppet-nodejs/issues/322)
- /usr/bin/npm doesn't exist when setting a nodejs::npm::global\_config\_entry [\#214](https://github.com/voxpupuli/puppet-nodejs/issues/214)

**Merged pull requests:**

- Add info for upgrades, repository priorities [\#352](https://github.com/voxpupuli/puppet-nodejs/pull/352) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Remove epel from fixtures [\#346](https://github.com/voxpupuli/puppet-nodejs/pull/346) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Remove EOL operatingsystems [\#341](https://github.com/voxpupuli/puppet-nodejs/pull/341) ([ekohl](https://github.com/ekohl))

## [v4.0.1](https://github.com/voxpupuli/puppet-nodejs/tree/v4.0.1) (2017-11-15)

[Full Changelog](https://github.com/voxpupuli/puppet-nodejs/compare/v4.0.0...v4.0.1)

**Fixed bugs:**

- apt pin error [\#333](https://github.com/voxpupuli/puppet-nodejs/issues/333)

**Closed issues:**

- Docs: Update repo\_url\_suffix to list current versions available [\#331](https://github.com/voxpupuli/puppet-nodejs/issues/331)

**Merged pull requests:**

- v4.0.1 [\#338](https://github.com/voxpupuli/puppet-nodejs/pull/338) ([TraGicCode](https://github.com/TraGicCode))
- Update known valid $repo\_url\_suffix values [\#337](https://github.com/voxpupuli/puppet-nodejs/pull/337) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Set default value for $repo\_pin to undef [\#334](https://github.com/voxpupuli/puppet-nodejs/pull/334) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Use the simpler calls for acceptance tests [\#330](https://github.com/voxpupuli/puppet-nodejs/pull/330) ([wyardley](https://github.com/wyardley))

## [v4.0.0](https://github.com/voxpupuli/puppet-nodejs/tree/v4.0.0) (2017-10-17)

[Full Changelog](https://github.com/voxpupuli/puppet-nodejs/compare/v3.1.0...v4.0.0)

**Implemented enhancements:**

- Don't restrict which Fedora versions can use the NodeSource repository [\#324](https://github.com/voxpupuli/puppet-nodejs/issues/324)
- Running `npm install` in a package dir with no arguments [\#154](https://github.com/voxpupuli/puppet-nodejs/issues/154)
- Allow all Fedora versions to use NodeSource [\#325](https://github.com/voxpupuli/puppet-nodejs/pull/325) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Add an option to install npm deps from package.json [\#300](https://github.com/voxpupuli/puppet-nodejs/pull/300) ([poikilotherm](https://github.com/poikilotherm))

**Fixed bugs:**

- Does not install on Ubuntu 16.04. [\#246](https://github.com/voxpupuli/puppet-nodejs/issues/246)
- installing nodejs 4 leads to npm being installed as well, which fails the nodejs install [\#165](https://github.com/voxpupuli/puppet-nodejs/issues/165)

**Closed issues:**

- Add support for NodeJS 8.x [\#323](https://github.com/voxpupuli/puppet-nodejs/issues/323)
- Unable to update Node version [\#285](https://github.com/voxpupuli/puppet-nodejs/issues/285)
- Unable to install older version if EPEL present [\#258](https://github.com/voxpupuli/puppet-nodejs/issues/258)

**Merged pull requests:**

- Deprecate EOL Fedora versions [\#327](https://github.com/voxpupuli/puppet-nodejs/pull/327) ([ghoneycutt](https://github.com/ghoneycutt))

## [v3.1.0](https://github.com/voxpupuli/puppet-nodejs/tree/v3.1.0) (2017-09-18)

[Full Changelog](https://github.com/voxpupuli/puppet-nodejs/compare/v3.0.0...v3.1.0)

**Breaking changes:**

- Turn off  legacy symlinks for ubuntu 16.04 [\#317](https://github.com/voxpupuli/puppet-nodejs/pull/317) ([guerremdq](https://github.com/guerremdq))

**Implemented enhancements:**

- Create some Beaker acceptance tests [\#139](https://github.com/voxpupuli/puppet-nodejs/issues/139)

**Fixed bugs:**

- Resolve issues with tests failing [\#319](https://github.com/voxpupuli/puppet-nodejs/pull/319) ([wyardley](https://github.com/wyardley))

**Closed issues:**

- EPEL now has dependency on http-parser [\#307](https://github.com/voxpupuli/puppet-nodejs/issues/307)

**Merged pull requests:**

- Adjust supported Puppet version back to 4.7.1 [\#316](https://github.com/voxpupuli/puppet-nodejs/pull/316) ([wyardley](https://github.com/wyardley))
- Add the 'an idempotent resource' shared example [\#313](https://github.com/voxpupuli/puppet-nodejs/pull/313) ([ekohl](https://github.com/ekohl))
- Update puppet version, deprecate some older versions of OSes [\#311](https://github.com/voxpupuli/puppet-nodejs/pull/311) ([wyardley](https://github.com/wyardley))
- Replace anchors with 'contain' [\#310](https://github.com/voxpupuli/puppet-nodejs/pull/310) ([wyardley](https://github.com/wyardley))
- Update acceptance tests, add EPEL test case for RedHat acceptance tests [\#308](https://github.com/voxpupuli/puppet-nodejs/pull/308) ([wyardley](https://github.com/wyardley))

## [v3.0.0](https://github.com/voxpupuli/puppet-nodejs/tree/v3.0.0) (2017-06-15)

[Full Changelog](https://github.com/voxpupuli/puppet-nodejs/compare/v2.3.0...v3.0.0)

**Implemented enhancements:**

- NPM Proxy [\#290](https://github.com/voxpupuli/puppet-nodejs/issues/290)
- npmrc can take k,v [\#292](https://github.com/voxpupuli/puppet-nodejs/pull/292) ([Poil](https://github.com/Poil))

**Fixed bugs:**

- Set explicit params for debian jessie [\#274](https://github.com/voxpupuli/puppet-nodejs/pull/274) ([ghost](https://github.com/ghost))

**Closed issues:**

- CentOS 6 3.8 is broken [\#289](https://github.com/voxpupuli/puppet-nodejs/issues/289)
- Centos 6.6 and 7 - Cannot retrieve repository metadata [\#288](https://github.com/voxpupuli/puppet-nodejs/issues/288)
- repo created by puppet [\#284](https://github.com/voxpupuli/puppet-nodejs/issues/284)
- r [\#279](https://github.com/voxpupuli/puppet-nodejs/issues/279)
- Explicitly put parameters for Debian Jessie [\#272](https://github.com/voxpupuli/puppet-nodejs/issues/272)

**Merged pull requests:**

- replace validate\_\* with datatypes [\#302](https://github.com/voxpupuli/puppet-nodejs/pull/302) ([bastelfreak](https://github.com/bastelfreak))
- Fix github license detection [\#299](https://github.com/voxpupuli/puppet-nodejs/pull/299) ([alexjfisher](https://github.com/alexjfisher))
- Revert "DO NOT MERGE: Prevent provider blowing up on ruby 1.8 agents" [\#296](https://github.com/voxpupuli/puppet-nodejs/pull/296) ([roidelapluie](https://github.com/roidelapluie))
- Update README for npmrc\_config [\#295](https://github.com/voxpupuli/puppet-nodejs/pull/295) ([Poil](https://github.com/Poil))
- Fix puppetlint [\#293](https://github.com/voxpupuli/puppet-nodejs/pull/293) ([Poil](https://github.com/Poil))
- Prevent provider blowing up on ruby 1.8 agents [\#282](https://github.com/voxpupuli/puppet-nodejs/pull/282) ([alexjfisher](https://github.com/alexjfisher))
- Modulesync 0.19.0 [\#276](https://github.com/voxpupuli/puppet-nodejs/pull/276) ([bastelfreak](https://github.com/bastelfreak))

## [v2.3.0](https://github.com/voxpupuli/puppet-nodejs/tree/v2.3.0) (2017-01-13)

[Full Changelog](https://github.com/voxpupuli/puppet-nodejs/compare/v2.2.0...v2.3.0)

**Implemented enhancements:**

- Provide NodeJS 7.x [\#270](https://github.com/voxpupuli/puppet-nodejs/issues/270)

**Fixed bugs:**

- incorrect repo validation for Ubuntu 15.04/15.10 [\#238](https://github.com/voxpupuli/puppet-nodejs/issues/238)

**Closed issues:**

- Unable to install nodejs 5x [\#273](https://github.com/voxpupuli/puppet-nodejs/issues/273)

**Merged pull requests:**

- Don't validate repo\_url\_suffix [\#271](https://github.com/voxpupuli/puppet-nodejs/pull/271) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Bump min version\_requirement for Puppet + dep [\#268](https://github.com/voxpupuli/puppet-nodejs/pull/268) ([juniorsysadmin](https://github.com/juniorsysadmin))
- update README to reflect nodejs versions 6.x and version 7.x [\#264](https://github.com/voxpupuli/puppet-nodejs/pull/264) ([brahman81](https://github.com/brahman81))
- Fix repo validation regexps for Ubuntu 15.04/15.10 \(\#238\) [\#239](https://github.com/voxpupuli/puppet-nodejs/pull/239) ([drkp](https://github.com/drkp))

## [v2.2.0](https://github.com/voxpupuli/puppet-nodejs/tree/v2.2.0) (2016-12-08)

[Full Changelog](https://github.com/voxpupuli/puppet-nodejs/compare/v2.1.0...v2.2.0)

**Implemented enhancements:**

- Vox Pupuli Elections [\#245](https://github.com/voxpupuli/puppet-nodejs/issues/245)

**Merged pull requests:**

- \[FIX\] Nodesource 6.x nodejs package replaces nodejs-dev & npm packages [\#261](https://github.com/voxpupuli/puppet-nodejs/pull/261) ([mxcoder](https://github.com/mxcoder))
- provider: add support for install\_options [\#260](https://github.com/voxpupuli/puppet-nodejs/pull/260) ([ghost](https://github.com/ghost))
- Add missing badges [\#256](https://github.com/voxpupuli/puppet-nodejs/pull/256) ([dhoppe](https://github.com/dhoppe))
- Metric/BlockLength -\> Metrics/BlockLength [\#255](https://github.com/voxpupuli/puppet-nodejs/pull/255) ([bastelfreak](https://github.com/bastelfreak))
- Actually remove gpg\_key dependency. [\#253](https://github.com/voxpupuli/puppet-nodejs/pull/253) ([MG2R](https://github.com/MG2R))

## [v2.1.0](https://github.com/voxpupuli/puppet-nodejs/tree/v2.1.0) (2016-10-05)

[Full Changelog](https://github.com/voxpupuli/puppet-nodejs/compare/v2.0.1...v2.1.0)

**Closed issues:**

- Puppet Forge still has 0.8.0 as latest release [\#237](https://github.com/voxpupuli/puppet-nodejs/issues/237)
- npm provider fail \(module not working\) on CentOS6 [\#235](https://github.com/voxpupuli/puppet-nodejs/issues/235)
- Add apt module to dependency list in metadata.json [\#232](https://github.com/voxpupuli/puppet-nodejs/issues/232)

**Merged pull requests:**

- Fixes debian legacy links on Ubuntu 16.04 [\#251](https://github.com/voxpupuli/puppet-nodejs/pull/251) ([petems](https://github.com/petems))
- release 2.1.0 [\#250](https://github.com/voxpupuli/puppet-nodejs/pull/250) ([bastelfreak](https://github.com/bastelfreak))
- Modulesync 0.12.9 [\#249](https://github.com/voxpupuli/puppet-nodejs/pull/249) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Ignore npm cache lines when calling 'npm view' for latest version [\#244](https://github.com/voxpupuli/puppet-nodejs/pull/244) ([domcleal](https://github.com/domcleal))
- npm is required on 16.04 [\#242](https://github.com/voxpupuli/puppet-nodejs/pull/242) ([gabriel403](https://github.com/gabriel403))
- add fedora 22 and 23 [\#231](https://github.com/voxpupuli/puppet-nodejs/pull/231) ([javierwilson](https://github.com/javierwilson))

## [v2.0.1](https://github.com/voxpupuli/puppet-nodejs/tree/v2.0.1) (2016-06-02)

[Full Changelog](https://github.com/voxpupuli/puppet-nodejs/compare/v2.0.0...v2.0.1)

**Closed issues:**

- No support for Xenial with NodeJS6 [\#228](https://github.com/voxpupuli/puppet-nodejs/issues/228)
- Module v2.0.0 error on CentOS 6.6 [\#227](https://github.com/voxpupuli/puppet-nodejs/issues/227)
- Puppet Forge outdated [\#226](https://github.com/voxpupuli/puppet-nodejs/issues/226)
- new release to fix Nodesource 4.x on CentOS 6.7 [\#222](https://github.com/voxpupuli/puppet-nodejs/issues/222)
- Question: uninstall nodejs entirely [\#210](https://github.com/voxpupuli/puppet-nodejs/issues/210)

**Merged pull requests:**

- Release 2.0.1 [\#230](https://github.com/voxpupuli/puppet-nodejs/pull/230) ([bastelfreak](https://github.com/bastelfreak))
- Add support for new versions of Ubuntu/NodeJS [\#229](https://github.com/voxpupuli/puppet-nodejs/pull/229) ([ColinHebert](https://github.com/ColinHebert))

## [v2.0.0](https://github.com/voxpupuli/puppet-nodejs/tree/v2.0.0) (2016-05-22)

[Full Changelog](https://github.com/voxpupuli/puppet-nodejs/compare/v1.3.0...v2.0.0)

**Fixed bugs:**

- Use npm to install a specific npm version [\#160](https://github.com/voxpupuli/puppet-nodejs/issues/160)
- Can't ensure latest if package is not instatlled [\#158](https://github.com/voxpupuli/puppet-nodejs/issues/158)

**Closed issues:**

- provider broken on Puppet v3.8.6 w/ Ruby 1.8.7 [\#217](https://github.com/voxpupuli/puppet-nodejs/issues/217)
- Always installs node '0.10.42', but need '5.x', and npm [\#208](https://github.com/voxpupuli/puppet-nodejs/issues/208)
- Caveat section in the README should be removed after feature check implemented [\#206](https://github.com/voxpupuli/puppet-nodejs/issues/206)
- Feature check is not being re-evaluated during the run [\#204](https://github.com/voxpupuli/puppet-nodejs/issues/204)
- Provider should confine to feature, which should check if npm is actually installed [\#202](https://github.com/voxpupuli/puppet-nodejs/issues/202)
- Upgrade from 4.x to 5.x, Downgrade from 5.x to 4.x [\#197](https://github.com/voxpupuli/puppet-nodejs/issues/197)
- Expand rspec tests that were modified for Rubocop [\#193](https://github.com/voxpupuli/puppet-nodejs/issues/193)
- undefined method `ref' for nil:NilClass [\#185](https://github.com/voxpupuli/puppet-nodejs/issues/185)
- $repo\_url\_suffix ignores 5.x and 4.x \(or others\) [\#184](https://github.com/voxpupuli/puppet-nodejs/issues/184)
- puppetforge reports old version [\#179](https://github.com/voxpupuli/puppet-nodejs/issues/179)

**Merged pull requests:**

- Node 6 is now available on EL6 & EL7 [\#225](https://github.com/voxpupuli/puppet-nodejs/pull/225) ([tapsboy](https://github.com/tapsboy))
- Prepare for release 2.0.0 [\#224](https://github.com/voxpupuli/puppet-nodejs/pull/224) ([bastelfreak](https://github.com/bastelfreak))
- Fix ordering bug when using global\_config\_entry and managing npm [\#221](https://github.com/voxpupuli/puppet-nodejs/pull/221) ([ghoneycutt](https://github.com/ghoneycutt))
- Document NPM's behavior of adding a trailing slash to URL's [\#220](https://github.com/voxpupuli/puppet-nodejs/pull/220) ([ghoneycutt](https://github.com/ghoneycutt))
- Do not hardcode the 'root' group name, use the 'gid' for that. [\#219](https://github.com/voxpupuli/puppet-nodejs/pull/219) ([buzzdeee](https://github.com/buzzdeee))
- Manage /root/.npmrc [\#216](https://github.com/voxpupuli/puppet-nodejs/pull/216) ([ghoneycutt](https://github.com/ghoneycutt))
- Update validation for EL 6. [\#213](https://github.com/voxpupuli/puppet-nodejs/pull/213) ([loopiv](https://github.com/loopiv))
- Fixes \#206 - Remove the caveat section from the readme [\#207](https://github.com/voxpupuli/puppet-nodejs/pull/207) ([imriz](https://github.com/imriz))
- Fixes \#204 - Workaround PUP-5985 [\#205](https://github.com/voxpupuli/puppet-nodejs/pull/205) ([imriz](https://github.com/imriz))
- Fixes \#202 - Implement a feature check for npm [\#203](https://github.com/voxpupuli/puppet-nodejs/pull/203) ([imriz](https://github.com/imriz))
- ensure apt-get update is executed before installing packages [\#201](https://github.com/voxpupuli/puppet-nodejs/pull/201) ([saz](https://github.com/saz))
- Modulesync [\#200](https://github.com/voxpupuli/puppet-nodejs/pull/200) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Use npm view package version, fix ensure=\>latest bug [\#199](https://github.com/voxpupuli/puppet-nodejs/pull/199) ([joelgarboden](https://github.com/joelgarboden))
- Making it possible to provide concrete nodejs versions to force upgrade/downgrade \(\#197\) [\#198](https://github.com/voxpupuli/puppet-nodejs/pull/198) ([fstr](https://github.com/fstr))
- Reverse Rubocop ugliness [\#196](https://github.com/voxpupuli/puppet-nodejs/pull/196) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Change npm\_package\_name from "undef" to "false" for better comparison. [\#195](https://github.com/voxpupuli/puppet-nodejs/pull/195) ([x3dfxjunkie](https://github.com/x3dfxjunkie))
- Correct badge location [\#194](https://github.com/voxpupuli/puppet-nodejs/pull/194) ([rnelson0](https://github.com/rnelson0))

## [v1.3.0](https://github.com/voxpupuli/puppet-nodejs/tree/v1.3.0) (2016-01-07)

[Full Changelog](https://github.com/voxpupuli/puppet-nodejs/compare/1.2.0...v1.3.0)

**Implemented enhancements:**

- Support non-default \(i.e. 0.12\) versions on RedHat [\#159](https://github.com/voxpupuli/puppet-nodejs/issues/159)
- Make repo\_url\_suffix to be usable for RH/CentOS [\#174](https://github.com/voxpupuli/puppet-nodejs/pull/174) ([tsde](https://github.com/tsde))

**Closed issues:**

- Puppetforge nodejs is not the same version as on github [\#182](https://github.com/voxpupuli/puppet-nodejs/issues/182)
- What needs to be done to make this puppet 4 ready? [\#175](https://github.com/voxpupuli/puppet-nodejs/issues/175)
- Possibly missing dependency on puppetlabs-apt [\#172](https://github.com/voxpupuli/puppet-nodejs/issues/172)
- Nodejs package is installed before apt is updated [\#171](https://github.com/voxpupuli/puppet-nodejs/issues/171)
- install dependencies from package.json [\#167](https://github.com/voxpupuli/puppet-nodejs/issues/167)
- undefined method `ref' for nil:NilClass on v1.1.0 [\#149](https://github.com/voxpupuli/puppet-nodejs/issues/149)

**Merged pull requests:**

- prep release for 1.3.0 [\#192](https://github.com/voxpupuli/puppet-nodejs/pull/192) ([igalic](https://github.com/igalic))
- fix\(rubocop\) clean up rubocop errors [\#191](https://github.com/voxpupuli/puppet-nodejs/pull/191) ([igalic](https://github.com/igalic))
- WIP: Attempt to fix failng Rubocop lint checks [\#190](https://github.com/voxpupuli/puppet-nodejs/pull/190) ([juniorsysadmin](https://github.com/juniorsysadmin))
- fix\(examples\) puppet lint complains about relative names [\#189](https://github.com/voxpupuli/puppet-nodejs/pull/189) ([igalic](https://github.com/igalic))
- Update from voxpupuli modulesync\_config [\#188](https://github.com/voxpupuli/puppet-nodejs/pull/188) ([igalic](https://github.com/igalic))
- move secure line into .sync \(in prep for msync\) [\#186](https://github.com/voxpupuli/puppet-nodejs/pull/186) ([igalic](https://github.com/igalic))
- Updates README with spaceship collector advice [\#183](https://github.com/voxpupuli/puppet-nodejs/pull/183) ([petems](https://github.com/petems))
- Fix notes about repo\_url\_suffix usage in README [\#181](https://github.com/voxpupuli/puppet-nodejs/pull/181) ([tsde](https://github.com/tsde))
- Add note oninstalling node 5.x [\#180](https://github.com/voxpupuli/puppet-nodejs/pull/180) ([tarjei](https://github.com/tarjei))
- Bump minimum Puppet version to 3.7.0 [\#178](https://github.com/voxpupuli/puppet-nodejs/pull/178) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Update the puppet version requirement since tests and implementations… [\#177](https://github.com/voxpupuli/puppet-nodejs/pull/177) ([ghost](https://github.com/ghost))
- Fix repo\_url\_suffix regex validation [\#176](https://github.com/voxpupuli/puppet-nodejs/pull/176) ([tsde](https://github.com/tsde))
- Fixed typographical error, changed arbitary to arbitrary in README. [\#170](https://github.com/voxpupuli/puppet-nodejs/pull/170) ([orthographic-pedant](https://github.com/orthographic-pedant))
- Remove soft dependency on treydock/gpg\_key [\#152](https://github.com/voxpupuli/puppet-nodejs/pull/152) ([juniorsysadmin](https://github.com/juniorsysadmin))

## [1.2.0](https://github.com/voxpupuli/puppet-nodejs/tree/1.2.0) (2015-08-20)

[Full Changelog](https://github.com/voxpupuli/puppet-nodejs/compare/1.1.0...1.2.0)

**Closed issues:**

- Add a dependency for treydock/gpg [\#143](https://github.com/voxpupuli/puppet-nodejs/issues/143)
- release 1.0.0 [\#142](https://github.com/voxpupuli/puppet-nodejs/issues/142)
- Fix deprecated use of should syntax in provider RSpec test [\#140](https://github.com/voxpupuli/puppet-nodejs/issues/140)
- Fix RSpec tests so that they run successfully under docker containers [\#137](https://github.com/voxpupuli/puppet-nodejs/issues/137)

**Merged pull requests:**

- "Gpg module is gpg\_key not gpg" [\#164](https://github.com/voxpupuli/puppet-nodejs/pull/164) ([nibalizer](https://github.com/nibalizer))
- "Add dependency on treydock/gpg\_key" [\#163](https://github.com/voxpupuli/puppet-nodejs/pull/163) ([nibalizer](https://github.com/nibalizer))
- "Prep 1.2.0 Release" [\#162](https://github.com/voxpupuli/puppet-nodejs/pull/162) ([nibalizer](https://github.com/nibalizer))
- Allowed home environment variable to be set [\#161](https://github.com/voxpupuli/puppet-nodejs/pull/161) ([mootpt](https://github.com/mootpt))
- Fix failing provider RSpec test when running on docker [\#156](https://github.com/voxpupuli/puppet-nodejs/pull/156) ([juniorsysadmin](https://github.com/juniorsysadmin))
- fixing amazon default settings [\#155](https://github.com/voxpupuli/puppet-nodejs/pull/155) ([webratz](https://github.com/webratz))
- Fix missing trailing comma and os version check [\#153](https://github.com/voxpupuli/puppet-nodejs/pull/153) ([juniorsysadmin](https://github.com/juniorsysadmin))
- RSpec tests: Convert should to expect using transpec [\#151](https://github.com/voxpupuli/puppet-nodejs/pull/151) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Update .travis.yml [\#150](https://github.com/voxpupuli/puppet-nodejs/pull/150) ([juniorsysadmin](https://github.com/juniorsysadmin))

## [1.1.0](https://github.com/voxpupuli/puppet-nodejs/tree/1.1.0) (2015-06-24)

[Full Changelog](https://github.com/voxpupuli/puppet-nodejs/compare/1.0.0...1.1.0)

**Merged pull requests:**

- Prep for Travis push releases [\#148](https://github.com/voxpupuli/puppet-nodejs/pull/148) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Amend CHANGELOG in preparation for 1.1.0 [\#147](https://github.com/voxpupuli/puppet-nodejs/pull/147) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Make repo::nodesource::apt compatible with puppetlabs-apt 2.x only [\#133](https://github.com/voxpupuli/puppet-nodejs/pull/133) ([juniorsysadmin](https://github.com/juniorsysadmin))

## [1.0.0](https://github.com/voxpupuli/puppet-nodejs/tree/1.0.0) (2015-06-12)

[Full Changelog](https://github.com/voxpupuli/puppet-nodejs/compare/0.8.0...1.0.0)

**Closed issues:**

- Support nodejs-legacy package for Debian [\#67](https://github.com/voxpupuli/puppet-nodejs/issues/67)
- Release new version to the forge [\#60](https://github.com/voxpupuli/puppet-nodejs/issues/60)
- Unmet dependencies installing node and npm on Debian 7 \(Wheezy\) [\#58](https://github.com/voxpupuli/puppet-nodejs/issues/58)
- NPN Packages Global install on centos [\#57](https://github.com/voxpupuli/puppet-nodejs/issues/57)
- Enforce that npm is installed with collectors before using it [\#54](https://github.com/voxpupuli/puppet-nodejs/issues/54)
- Proxy config fails on ubuntu when using the managed repo [\#51](https://github.com/voxpupuli/puppet-nodejs/issues/51)
- Please note node version in readme [\#50](https://github.com/voxpupuli/puppet-nodejs/issues/50)
- EL packages are ancient and from unofficial repo [\#49](https://github.com/voxpupuli/puppet-nodejs/issues/49)
- Nodejs version under ubuntu [\#48](https://github.com/voxpupuli/puppet-nodejs/issues/48)
- Add support for Windows 7 [\#44](https://github.com/voxpupuli/puppet-nodejs/issues/44)
- "Could not update: Got nil value for ensure" on "ensure =\> latest" [\#43](https://github.com/voxpupuli/puppet-nodejs/issues/43)
- nodejs/manifests/params.pp installs /etc/yum.repos.d/nodejs-stable.repo which doesn't work with Scientific Linux 6.4 [\#38](https://github.com/voxpupuli/puppet-nodejs/issues/38)
- node.js manifests/params.pp & manifests/init.pp should support Scientific Linux [\#37](https://github.com/voxpupuli/puppet-nodejs/issues/37)
- EPEL nodejs conflicting with nodejs-compat-symlinks [\#33](https://github.com/voxpupuli/puppet-nodejs/issues/33)

**Merged pull requests:**

- Added npm package dependency for Archlinux [\#146](https://github.com/voxpupuli/puppet-nodejs/pull/146) ([justin8](https://github.com/justin8))
- Update README [\#141](https://github.com/voxpupuli/puppet-nodejs/pull/141) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Fix metadata.json [\#136](https://github.com/voxpupuli/puppet-nodejs/pull/136) ([mcanevet](https://github.com/mcanevet))
- Fix stdlib and Puppet version requirements in metadata.json [\#130](https://github.com/voxpupuli/puppet-nodejs/pull/130) ([juniorsysadmin](https://github.com/juniorsysadmin))

## [0.8.0](https://github.com/voxpupuli/puppet-nodejs/tree/0.8.0) (2015-05-11)

[Full Changelog](https://github.com/voxpupuli/puppet-nodejs/compare/0.7.1...0.8.0)

**Breaking changes:**

- \(MODULES-1637\) Major refactor [\#103](https://github.com/voxpupuli/puppet-nodejs/pull/103) ([juniorsysadmin](https://github.com/juniorsysadmin))

**Merged pull requests:**

- release prep 0.8.0 [\#134](https://github.com/voxpupuli/puppet-nodejs/pull/134) ([tphoney](https://github.com/tphoney))
- Don't use deprecated chocolatey module [\#132](https://github.com/voxpupuli/puppet-nodejs/pull/132) ([juniorsysadmin](https://github.com/juniorsysadmin))
- pin apt for acceptance tests [\#131](https://github.com/voxpupuli/puppet-nodejs/pull/131) ([tphoney](https://github.com/tphoney))
- Use ~\> 3.0 not ~\> 3.5.0 [\#127](https://github.com/voxpupuli/puppet-nodejs/pull/127) ([underscorgan](https://github.com/underscorgan))
- Document that puppetlabs-apt versions less than 2.x are required [\#126](https://github.com/voxpupuli/puppet-nodejs/pull/126) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Handle NodeSource Debian URL suffixes [\#125](https://github.com/voxpupuli/puppet-nodejs/pull/125) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Fix yumrepo parameter typo [\#124](https://github.com/voxpupuli/puppet-nodejs/pull/124) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Update rspec-puppet tests for 2.0 [\#123](https://github.com/voxpupuli/puppet-nodejs/pull/123) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Fix class containment [\#121](https://github.com/voxpupuli/puppet-nodejs/pull/121) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Fix gpg key checking warings after f588f26 in puppetlabs-apt [\#119](https://github.com/voxpupuli/puppet-nodejs/pull/119) ([paroga](https://github.com/paroga))
- Make it obvious NodeSource doesn't have a npm package [\#116](https://github.com/voxpupuli/puppet-nodejs/pull/116) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Change ruby provider to NPM provider [\#114](https://github.com/voxpupuli/puppet-nodejs/pull/114) ([hunner](https://github.com/hunner))
- nodejs::npm::target is required [\#113](https://github.com/voxpupuli/puppet-nodejs/pull/113) ([hunner](https://github.com/hunner))
- Make sure nodejs::install is private [\#112](https://github.com/voxpupuli/puppet-nodejs/pull/112) ([hunner](https://github.com/hunner))
- README.md [\#111](https://github.com/voxpupuli/puppet-nodejs/pull/111) ([malnick](https://github.com/malnick))

## [0.7.1](https://github.com/voxpupuli/puppet-nodejs/tree/0.7.1) (2015-01-21)

[Full Changelog](https://github.com/voxpupuli/puppet-nodejs/compare/0.7.0...0.7.1)

**Merged pull requests:**

- 0.7.1 prep [\#107](https://github.com/voxpupuli/puppet-nodejs/pull/107) ([underscorgan](https://github.com/underscorgan))
- Correct broken application of PR \#70 [\#106](https://github.com/voxpupuli/puppet-nodejs/pull/106) ([theothertom](https://github.com/theothertom))

## [0.7.0](https://github.com/voxpupuli/puppet-nodejs/tree/0.7.0) (2015-01-21)

[Full Changelog](https://github.com/voxpupuli/puppet-nodejs/compare/0.6.1...0.7.0)

**Merged pull requests:**

- 0.7.0 prep [\#105](https://github.com/voxpupuli/puppet-nodejs/pull/105) ([underscorgan](https://github.com/underscorgan))
- Add max\_nesting parameter to npm list json parse [\#101](https://github.com/voxpupuli/puppet-nodejs/pull/101) ([rangoy](https://github.com/rangoy))
- Replace Chris Lea's PPA with the Nodesource repo [\#100](https://github.com/voxpupuli/puppet-nodejs/pull/100) ([atrepca](https://github.com/atrepca))
- Fix typo in README.md [\#98](https://github.com/voxpupuli/puppet-nodejs/pull/98) ([zorbash](https://github.com/zorbash))
- Parameterize package names [\#97](https://github.com/voxpupuli/puppet-nodejs/pull/97) ([skpy](https://github.com/skpy))
- FM-1523: Added module summary to metadata.json [\#95](https://github.com/voxpupuli/puppet-nodejs/pull/95) ([jbondpdx](https://github.com/jbondpdx))
- Add Archlinux support [\#90](https://github.com/voxpupuli/puppet-nodejs/pull/90) ([Filirom1](https://github.com/Filirom1))
- updated travis to current versions of puppet [\#79](https://github.com/voxpupuli/puppet-nodejs/pull/79) ([jlambert121](https://github.com/jlambert121))
- fix requires for proxy config when on ubuntu \#51 [\#70](https://github.com/voxpupuli/puppet-nodejs/pull/70) ([wenlock](https://github.com/wenlock))

## [0.6.1](https://github.com/voxpupuli/puppet-nodejs/tree/0.6.1) (2014-07-15)

[Full Changelog](https://github.com/voxpupuli/puppet-nodejs/compare/0.6.0...0.6.1)

**Merged pull requests:**

- Prepare 0.6.1 release. [\#83](https://github.com/voxpupuli/puppet-nodejs/pull/83) ([apenney](https://github.com/apenney))
- Prepare 0.6.0 release. [\#81](https://github.com/voxpupuli/puppet-nodejs/pull/81) ([underscorgan](https://github.com/underscorgan))

## [0.6.0](https://github.com/voxpupuli/puppet-nodejs/tree/0.6.0) (2014-06-18)

[Full Changelog](https://github.com/voxpupuli/puppet-nodejs/compare/0.5.0...0.6.0)

**Merged pull requests:**

- Fix the specs. [\#76](https://github.com/voxpupuli/puppet-nodejs/pull/76) ([apenney](https://github.com/apenney))
- Remove metadata, since it's not correct [\#74](https://github.com/voxpupuli/puppet-nodejs/pull/74) ([hunner](https://github.com/hunner))
- install nodejs and npm on gentoo [\#71](https://github.com/voxpupuli/puppet-nodejs/pull/71) ([hairmare](https://github.com/hairmare))

## [0.5.0](https://github.com/voxpupuli/puppet-nodejs/tree/0.5.0) (2014-03-20)

[Full Changelog](https://github.com/voxpupuli/puppet-nodejs/compare/0.4.0...0.5.0)

**Merged pull requests:**

- Prepare a 0.5.0 release. [\#73](https://github.com/voxpupuli/puppet-nodejs/pull/73) ([apenney](https://github.com/apenney))
- Ubuntu uses uppercase for the operatingsystem fact [\#68](https://github.com/voxpupuli/puppet-nodejs/pull/68) ([barthoda](https://github.com/barthoda))
- add support for Scientific Linux operatingsystem [\#65](https://github.com/voxpupuli/puppet-nodejs/pull/65) ([faxm0dem](https://github.com/faxm0dem))
- Fix ubuntu development package being installed when dev flag is set to false [\#64](https://github.com/voxpupuli/puppet-nodejs/pull/64) ([vpassapera](https://github.com/vpassapera))
- Changed Amazon package name [\#61](https://github.com/voxpupuli/puppet-nodejs/pull/61) ([davideme](https://github.com/davideme))
- Set $HOME for npm execs \(pkgs like node-gym require\) [\#59](https://github.com/voxpupuli/puppet-nodejs/pull/59) ([patcon](https://github.com/patcon))
- Ignore exit codes from "npm list --json" as they can be misleading [\#56](https://github.com/voxpupuli/puppet-nodejs/pull/56) ([domcleal](https://github.com/domcleal))
- FM-103: Add metadata.json to all modules. [\#52](https://github.com/voxpupuli/puppet-nodejs/pull/52) ([apenney](https://github.com/apenney))
- Add Gemfile and update travis to test against modern versions of Puppet. [\#47](https://github.com/voxpupuli/puppet-nodejs/pull/47) ([apenney](https://github.com/apenney))
- Update README.md [\#32](https://github.com/voxpupuli/puppet-nodejs/pull/32) ([antoniojrod](https://github.com/antoniojrod))

## [0.4.0](https://github.com/voxpupuli/puppet-nodejs/tree/0.4.0) (2013-08-29)

[Full Changelog](https://github.com/voxpupuli/puppet-nodejs/compare/0.3.0...0.4.0)

**Closed issues:**

- Release to the Forge [\#39](https://github.com/voxpupuli/puppet-nodejs/issues/39)

**Merged pull requests:**

- Remove special cases for Precise [\#41](https://github.com/voxpupuli/puppet-nodejs/pull/41) ([lunaryorn](https://github.com/lunaryorn))
- Add version parameter [\#28](https://github.com/voxpupuli/puppet-nodejs/pull/28) ([bfirsh](https://github.com/bfirsh))

## [0.3.0](https://github.com/voxpupuli/puppet-nodejs/tree/0.3.0) (2013-08-01)

[Full Changelog](https://github.com/voxpupuli/puppet-nodejs/compare/0.2.1...0.3.0)

**Closed issues:**

- Ubuntu support? Or npm install failure [\#30](https://github.com/voxpupuli/puppet-nodejs/issues/30)

**Merged pull requests:**

- Prepare a 0.3.0 release. [\#40](https://github.com/voxpupuli/puppet-nodejs/pull/40) ([apenney](https://github.com/apenney))
- refactor to address issues 27 and 33 [\#36](https://github.com/voxpupuli/puppet-nodejs/pull/36) ([wolfspyre](https://github.com/wolfspyre))
- Fix to install failure's on Ubuntu [\#34](https://github.com/voxpupuli/puppet-nodejs/pull/34) ([siwilkins](https://github.com/siwilkins))

## [0.2.1](https://github.com/voxpupuli/puppet-nodejs/tree/0.2.1) (2012-12-28)

[Full Changelog](https://github.com/voxpupuli/puppet-nodejs/compare/0.3.1...0.2.1)

## [0.3.1](https://github.com/voxpupuli/puppet-nodejs/tree/0.3.1) (2012-12-28)

[Full Changelog](https://github.com/voxpupuli/puppet-nodejs/compare/0.2.0...0.3.1)

**Merged pull requests:**

- Bugfix/yumrepo: nodejs.tchol.org [\#26](https://github.com/voxpupuli/puppet-nodejs/pull/26) ([razorsedge](https://github.com/razorsedge))
- Fix typo in README.md [\#19](https://github.com/voxpupuli/puppet-nodejs/pull/19) ([jjbohn](https://github.com/jjbohn))
- Fix puppetlabs-apt link in README [\#17](https://github.com/voxpupuli/puppet-nodejs/pull/17) ([alefteris](https://github.com/alefteris))
- Fix Dynamic lookup of $lsbdistcodename  [\#13](https://github.com/voxpupuli/puppet-nodejs/pull/13) ([stephenrjohnson](https://github.com/stephenrjohnson))
- Add support for npm proxy configuration. [\#12](https://github.com/voxpupuli/puppet-nodejs/pull/12) ([nanliu](https://github.com/nanliu))
- Update for the new puppetlabs\_spec\_helper gem [\#11](https://github.com/voxpupuli/puppet-nodejs/pull/11) ([branan](https://github.com/branan))

## [0.2.0](https://github.com/voxpupuli/puppet-nodejs/tree/0.2.0) (2012-05-22)

[Full Changelog](https://github.com/voxpupuli/puppet-nodejs/compare/0.1.1...0.2.0)

**Merged pull requests:**

- Add new module release file. [\#10](https://github.com/voxpupuli/puppet-nodejs/pull/10) ([nanliu](https://github.com/nanliu))
- Nodejs npm provider and ppa changes. [\#9](https://github.com/voxpupuli/puppet-nodejs/pull/9) ([nanliu](https://github.com/nanliu))
- fix .travis.yml for the apt module repo rename [\#8](https://github.com/voxpupuli/puppet-nodejs/pull/8) ([branan](https://github.com/branan))
- Fix spec test bug on Puppet 2.6. [\#7](https://github.com/voxpupuli/puppet-nodejs/pull/7) ([nanliu](https://github.com/nanliu))
- Add files for Travis CI [\#6](https://github.com/voxpupuli/puppet-nodejs/pull/6) ([branan](https://github.com/branan))
- Add RedHat family support for Nodejs. [\#5](https://github.com/voxpupuli/puppet-nodejs/pull/5) ([nanliu](https://github.com/nanliu))

## [0.1.1](https://github.com/voxpupuli/puppet-nodejs/tree/0.1.1) (2012-05-07)

[Full Changelog](https://github.com/voxpupuli/puppet-nodejs/compare/0.1.0...0.1.1)

**Merged pull requests:**

- Release new module version. [\#4](https://github.com/voxpupuli/puppet-nodejs/pull/4) ([nanliu](https://github.com/nanliu))
- Include apt class instead of parametrized class. [\#3](https://github.com/voxpupuli/puppet-nodejs/pull/3) ([nanliu](https://github.com/nanliu))
- Update nodejs module for initial forge release. [\#1](https://github.com/voxpupuli/puppet-nodejs/pull/1) ([nanliu](https://github.com/nanliu))

## [0.1.0](https://github.com/voxpupuli/puppet-nodejs/tree/0.1.0) (2012-05-01)

[Full Changelog](https://github.com/voxpupuli/puppet-nodejs/compare/1bc8bfdf20c2b89f3169a211d63cfd6b986c93cb...0.1.0)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
