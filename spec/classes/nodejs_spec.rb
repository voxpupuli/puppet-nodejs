# frozen_string_literal: true

require 'spec_helper'

describe 'nodejs', type: :class do
  on_supported_os.each do |os, facts|
    next unless facts[:os]['family'] == 'Debian'

    context "on #{os}" do
      let :facts do
        facts
      end

      it 'the file resource root_npmrc should be in the catalog' do
        is_expected.to contain_file('root_npmrc').with(
          'ensure' => 'file',
          'path' => '/root/.npmrc',
          'owner' => 'root',
          'group' => '0',
          'mode' => '0600'
        )
      end

      context 'with npmrc_auth set to a string' do
        let :params do
          {
            npmrc_auth: 'dXNlcjpwYXNzd29yZA=='
          }
        end

        it { is_expected.to contain_file('root_npmrc').with_content(%r{^_auth="dXNlcjpwYXNzd29yZA=="$}) }
      end

      context 'with npmrc_config set to a hash' do
        let :params do
          {
            npmrc_config: { 'http-proxy' => 'http://localhost:8080/' }
          }
        end

        it { is_expected.to contain_file('root_npmrc').with_content(%r{^http-proxy=http://localhost:8080/$}) }
      end

      # manage_package_repo
      context 'with manage_package_repo set to true' do
        let :default_params do
          {
            manage_package_repo: true
          }
        end

        context 'and manage_nodejs_package set to true' do
          let :params do
            default_params.merge!(manage_nodejs_package: true)
          end

          it 'the nodejs package resource should be present' do
            is_expected.to contain_package('nodejs')
          end
        end

        context 'and manage_nodejs_package set to false' do
          let :params do
            default_params.merge!(manage_nodejs_package: false)
          end

          it 'the nodejs and dev package resources should not be present' do
            is_expected.not_to contain_package('nodejs')
            is_expected.not_to contain_package('libnode-dev')
          end
        end

        context 'and repo_class set to nodejs::repo::nodesource' do
          let :params do
            default_params.merge!(repo_class: 'nodejs::repo::nodesource')
          end

          it 'nodejs::repo::nodesource should be in the catalog' do
            is_expected.to contain_class('nodejs::repo::nodesource')
          end

          it 'nodejs::repo::nodesource::apt should be in the catalog' do
            is_expected.to contain_class('nodejs::repo::nodesource::apt')
          end
        end

        context 'and repo_priority set to 10' do
          let :params do
            default_params.merge!(repo_priority: '10')
          end

          it 'the repo apt::source resource should contain priority = 10' do
            is_expected.to contain_apt__pin('nodesource').with('priority' => '10')
          end
        end

        context 'and repo_priority not set' do
          let :params do
            default_params.merge!(repo_priority: :undef)
          end

          it 'the repo apt::source resource should contain priority = 990' do
            is_expected.to contain_apt__pin('nodesource').with('priority' => 990)
          end
        end

        context 'and repo_version set to 9' do
          let :params do
            default_params.merge!(repo_version: '9')
          end

          it 'the repo apt::source resource should contain location = [https://deb.nodesource.com/node_9.x]' do
            is_expected.to contain_apt__source('nodesource').with('location' => ['https://deb.nodesource.com/node_9.x'])
          end
        end

        context 'and repo_ensure set to present' do
          let :params do
            default_params.merge!(repo_ensure: 'present')
          end

          it 'the nodesource apt sources file should exist' do
            is_expected.to contain_apt__source('nodesource')
          end
        end

        context 'and repo_ensure set to absent' do
          let :params do
            default_params.merge!(repo_ensure: 'absent')
          end

          it 'the nodesource apt sources file should not exist' do
            is_expected.to contain_apt__source('nodesource').with('ensure' => 'absent')
          end
        end
      end

      context 'with manage_package_repo set to false' do
        let :params do
          {
            manage_package_repo: false
          }
        end

        it 'nodejs::repo::nodesource should not be in the catalog' do
          is_expected.not_to contain_class('nodejs::repo::nodesource')
        end
      end

      # nodejs_debug_package_ensure
      context 'with nodejs_debug_package_ensure set to installed' do
        let :params do
          {
            nodejs_debug_package_ensure: 'installed'
          }
        end

        it 'the nodejs package with debugging symbols should be installed' do
          is_expected.to contain_package('nodejs-dbg').with('ensure' => 'installed')
        end
      end

      context 'with nodejs_debug_package_ensure set to absent' do
        let :params do
          {
            nodejs_debug_package_ensure: 'absent'
          }
        end

        it 'the nodejs package with debugging symbols should not be present' do
          is_expected.to contain_package('nodejs-dbg').with('ensure' => 'absent')
        end
      end

      # nodejs_dev_package_ensure
      context 'with nodejs_dev_package_ensure set to installed' do
        let :params do
          {
            nodejs_dev_package_ensure: 'installed'
          }
        end

        it 'the nodejs development package should be installed' do
          is_expected.to contain_package('libnode-dev').with('ensure' => 'installed')
        end
      end

      context 'with nodejs_dev_package_ensure set to absent' do
        let :params do
          {
            nodejs_dev_package_ensure: 'absent'
          }
        end

        it 'the nodejs development package should not be present' do
          is_expected.to contain_package('libnode-dev').with('ensure' => 'absent')
        end
      end

      # nodejs_package_ensure
      context 'with nodejs_package_ensure set to installed' do
        let :params do
          {
            nodejs_package_ensure: 'installed'
          }
        end

        it 'the nodejs package should be installed' do
          is_expected.to contain_package('nodejs').with('ensure' => 'installed')
        end
      end

      context 'with nodejs_package_ensure set to absent' do
        let :params do
          {
            nodejs_package_ensure: 'absent'
          }
        end

        it 'the nodejs package should be absent' do
          is_expected.to contain_package('nodejs').with('ensure' => 'absent')
        end
      end

      # npm_package_ensure
      context 'with npm_package_ensure set to installed' do
        let :params do
          {
            npm_package_ensure: 'installed'
          }
        end

        it 'the npm package should be installed' do
          is_expected.to contain_package('npm').with('ensure' => 'installed')
        end
      end

      context 'with npm_package_ensure set to absent' do
        let :params do
          {
            npm_package_ensure: 'absent'
          }
        end

        it 'the npm package should be absent' do
          is_expected.to contain_package('npm').with('ensure' => 'absent')
        end
      end

      # npm_package_name
      context 'with npm_package_name set to false' do
        let :params do
          {
            npm_package_name: 'false'
          }
        end

        it 'the npm package resource should not be present' do
          is_expected.not_to contain_package('npm')
        end
      end
    end
  end

  ['7.0'].each do |operatingsystemrelease|
    osversions = operatingsystemrelease.split('.')
    operatingsystemmajrelease = osversions[0]

    operatingsystem     = 'CentOS'
    repo_baseurl        = 'https://rpm.nodesource.com/pub_16.x/nodistro/nodejs/$basearch'
    repo_descr          = 'Node.js Packages - $basearch'

    context "when run on #{operatingsystem} release #{operatingsystemrelease}" do
      let :facts do
        {
          'os' => {
            'family' => 'RedHat',
            'name' => operatingsystem,
            'release' => {
              'major' => operatingsystemmajrelease,
              'full' => operatingsystemrelease
            }
          }
        }
      end

      # manage_package_repo
      context 'with manage_package_repo set to true' do
        let :default_params do
          {
            manage_package_repo: true
          }
        end

        context 'and manage_nodejs_package set to true' do
          let :params do
            default_params.merge!(manage_nodejs_package: true)
          end

          it 'the nodejs package resource should be present' do
            is_expected.to contain_package('nodejs')
          end
        end

        context 'and manage_nodejs_package set to false' do
          let :params do
            default_params.merge!(manage_nodejs_package: false)
          end

          it 'the nodejs and dev package resources should not be present' do
            is_expected.not_to contain_package('nodejs')
            is_expected.not_to contain_package('nodejs-devel')
          end
        end

        context 'and repo_class set to nodejs::repo::nodesource' do
          let :params do
            default_params.merge!(repo_class: 'nodejs::repo::nodesource')
          end

          it 'nodejs::repo::nodesource should be in the catalog' do
            is_expected.to contain_class('nodejs::repo::nodesource')
          end

          it 'nodejs::repo::nodesource::yum should be in the catalog' do
            is_expected.to contain_class('nodejs::repo::nodesource::yum')
          end

          it 'the nodesource repo should contain the right description and baseurl' do
            is_expected.to contain_yumrepo('nodesource').with(
              'baseurl' => repo_baseurl,
              'descr' => repo_descr
            )
          end
        end

        context 'and repo_version set to 21' do
          let :params do
            default_params.merge!(repo_version: '21')
          end

          it 'the yum nodesource repo resource should contain baseurl = https://rpm.nodesource.com/pub_21.x/nodistro/nodejs/$basearch' do
            is_expected.to contain_yumrepo('nodesource').with('baseurl' => 'https://rpm.nodesource.com/pub_21.x/nodistro/nodejs/$basearch')
          end
        end

        context 'and repo_ensure set to present' do
          let :params do
            default_params.merge!(repo_ensure: 'present')
          end

          it 'the nodesource yum repo files should exist' do
            is_expected.to contain_yumrepo('nodesource')
          end
        end

        context 'and repo_ensure set to absent' do
          let :params do
            default_params.merge!(repo_ensure: 'absent')
          end

          it 'the nodesource yum repo files should not exist' do
            is_expected.to contain_yumrepo('nodesource').with('ensure' => 'absent')
          end
        end

        context 'and repo_proxy set to absent' do
          let :params do
            default_params.merge!(repo_proxy: 'absent')
          end

          it 'the yumrepo resource should contain proxy = absent' do
            is_expected.to contain_yumrepo('nodesource').with('proxy' => 'absent')
          end
        end

        context 'and repo_proxy set to http://proxy.localdomain.com' do
          let :params do
            default_params.merge!(repo_proxy: 'http://proxy.localdomain.com')
          end

          it 'the yumrepo resource should contain proxy = http://proxy.localdomain.com' do
            is_expected.to contain_yumrepo('nodesource').with('proxy' => 'http://proxy.localdomain.com')
          end
        end

        context 'and repo_proxy_password set to absent' do
          let :params do
            default_params.merge!(repo_proxy_password: 'absent')
          end

          it 'the yumrepo resource should contain proxy_password = absent' do
            is_expected.to contain_yumrepo('nodesource').with('proxy_password' => 'absent')
          end
        end

        context 'and repo_proxy_password set to password' do
          let :params do
            default_params.merge!(repo_proxy_password: 'password')
          end

          it 'the yumrepo resource should contain proxy_password = password' do
            is_expected.to contain_yumrepo('nodesource').with('proxy_password' => 'password')
          end
        end

        context 'and repo_proxy_username set to absent' do
          let :params do
            default_params.merge!(repo_proxy_username: 'absent')
          end

          it 'the yumrepo resource should contain proxy_username = absent' do
            is_expected.to contain_yumrepo('nodesource').with('proxy_username' => 'absent')
          end
        end

        context 'and repo_proxy_username set to proxyuser' do
          let :params do
            default_params.merge!(repo_proxy_username: 'proxyuser')
          end

          it 'the yumrepo resource should contain proxy_username = proxyuser' do
            is_expected.to contain_yumrepo('nodesource').with('proxy_username' => 'proxyuser')
          end
        end
      end

      context 'with manage_package_repo set to false' do
        let :params do
          {
            manage_package_repo: false
          }
        end

        it 'nodejs::repo::nodesource should not be in the catalog' do
          is_expected.not_to contain_class('nodejs::repo::nodesource')
        end
      end

      # nodejs_debug_package_ensure
      context 'with nodejs_debug_package_ensure set to installed' do
        let :params do
          {
            nodejs_debug_package_ensure: 'installed'
          }
        end

        it 'the nodejs package with debugging symbols should be installed' do
          is_expected.to contain_package('nodejs-debuginfo').with('ensure' => 'installed')
        end
      end

      context 'with nodejs_debug_package_ensure set to absent' do
        let :params do
          {
            nodejs_debug_package_ensure: 'absent'
          }
        end

        it 'the nodejs package with debugging symbols should not be present' do
          is_expected.to contain_package('nodejs-debuginfo').with('ensure' => 'absent')
        end
      end

      # nodejs_dev_package_ensure
      context 'with nodejs_dev_package_ensure set to installed' do
        let :params do
          {
            nodejs_dev_package_ensure: 'installed'
          }
        end

        it 'the nodejs development package should be installed' do
          is_expected.to contain_package('nodejs-devel').with('ensure' => 'installed')
        end
      end

      context 'with nodejs_dev_package_ensure set to absent' do
        let :params do
          {
            nodejs_dev_package_ensure: 'absent'
          }
        end

        it 'the nodejs development package should not be present' do
          is_expected.to contain_package('nodejs-devel').with('ensure' => 'absent')
        end
      end

      # nodejs_package_ensure
      context 'with nodejs_package_ensure set to installed' do
        let :params do
          {
            nodejs_package_ensure: 'installed'
          }
        end

        it 'the nodejs package should be present' do
          is_expected.to contain_package('nodejs').with('ensure' => 'installed')
        end
      end

      context 'with nodejs_package_ensure set to absent' do
        let :params do
          {
            nodejs_package_ensure: 'absent'
          }
        end

        it 'the nodejs package should be absent' do
          is_expected.to contain_package('nodejs').with('ensure' => 'absent')
        end
      end

      # npm_package_ensure
      context 'with npm_package_ensure set to installed' do
        let :params do
          {
            npm_package_ensure: 'installed'
          }
        end

        it 'the npm package should be present' do
          is_expected.to contain_package('npm').with('ensure' => 'installed')
        end
      end

      context 'with npm_package_ensure set to absent' do
        let :params do
          {
            npm_package_ensure: 'absent'
          }
        end

        it 'the npm package should be absent' do
          is_expected.to contain_package('npm').with('ensure' => 'absent')
        end
      end
    end
  end

  context 'when running on Suse' do
    let :facts do
      {
        'os' => {
          'family' => 'Suse',
          'name' => 'SLES'
        }
      }
    end

    # nodejs_debug_package_ensure
    context 'with nodejs_debug_package_ensure set to installed' do
      let :params do
        {
          nodejs_debug_package_ensure: 'installed'
        }
      end

      it 'the nodejs package with debugging symbols should be installed' do
        is_expected.to contain_package('nodejs-debuginfo').with('ensure' => 'installed')
      end
    end

    context 'with nodejs_debug_package_ensure set to absent' do
      let :params do
        {
          nodejs_debug_package_ensure: 'absent'
        }
      end

      it 'the nodejs package with debugging symbols should not be present' do
        is_expected.to contain_package('nodejs-debuginfo').with('ensure' => 'absent')
      end
    end

    # nodejs_dev_package_ensure
    context 'with nodejs_dev_package_ensure set to installed' do
      let :params do
        {
          nodejs_dev_package_ensure: 'installed'
        }
      end

      it 'the nodejs development package should be installed' do
        is_expected.to contain_package('nodejs-devel').with('ensure' => 'installed')
      end
    end

    context 'with nodejs_dev_package_ensure set to absent' do
      let :params do
        {
          nodejs_dev_package_ensure: 'absent'
        }
      end

      it 'the nodejs development package should not be present' do
        is_expected.to contain_package('nodejs-devel').with('ensure' => 'absent')
      end
    end

    # manage_nodejs_package
    context 'and manage_nodejs_package set to true' do
      let :params do
        {
          manage_nodejs_package: true
        }
      end

      it 'the nodejs package resource should be present' do
        is_expected.to contain_package('nodejs')
      end
    end

    context 'and manage_nodejs_package set to false' do
      let :params do
        {
          manage_nodejs_package: false
        }
      end

      it 'the nodejs and dev package resources should not be present' do
        is_expected.not_to contain_package('nodejs')
        is_expected.not_to contain_package('nodejs-devel')
      end
    end

    # nodejs_package_ensure
    context 'with nodejs_package_ensure set to installed' do
      let :params do
        {
          nodejs_package_ensure: 'installed'
        }
      end

      it 'the nodejs package should be present' do
        is_expected.to contain_package('nodejs').with('ensure' => 'installed')
      end
    end

    context 'with nodejs_package_ensure set to absent' do
      let :params do
        {
          nodejs_package_ensure: 'absent'
        }
      end

      it 'the nodejs package should be absent' do
        is_expected.to contain_package('nodejs').with('ensure' => 'absent')
      end
    end

    # npm_package_ensure
    context 'with npm_package_ensure set to installed' do
      let :params do
        {
          npm_package_ensure: 'installed'
        }
      end

      it 'the npm package should be present' do
        is_expected.to contain_package('npm').with('ensure' => 'installed')
      end
    end

    context 'with npm_package_ensure set to absent' do
      let :params do
        {
          npm_package_ensure: 'absent'
        }
      end

      it 'the npm package should be absent' do
        is_expected.to contain_package('npm').with('ensure' => 'absent')
      end
    end
  end

  context 'when running on Archlinux' do
    let :facts do
      {
        'os' => {
          'family' => 'Archlinux',
          'name' => 'Archlinux'
        }
      }
    end

    # manage_nodejs_package
    context 'and manage_nodejs_package set to true' do
      let :params do
        {
          manage_nodejs_package: true
        }
      end

      it 'the nodejs package resource should be present' do
        is_expected.to contain_package('nodejs')
      end
    end

    context 'and manage_nodejs_package set to false' do
      let :params do
        {
          manage_nodejs_package: false
        }
      end

      it 'the nodejs package resource should not be present' do
        is_expected.not_to contain_package('nodejs')
      end
    end

    # nodejs_package_ensure
    context 'with nodejs_package_ensure set to installed' do
      let :params do
        {
          nodejs_package_ensure: 'installed'
        }
      end

      it 'the nodejs package should be present' do
        is_expected.to contain_package('nodejs').with('ensure' => 'installed')
      end
    end

    context 'with nodejs_package_ensure set to absent' do
      let :params do
        {
          nodejs_package_ensure: 'absent'
        }
      end

      it 'the nodejs package should be absent' do
        is_expected.to contain_package('nodejs').with('ensure' => 'absent')
      end
    end
  end

  context 'when running on FreeBSD' do
    let :facts do
      {
        'os' => {
          'family' => 'FreeBSD',
          'name' => 'FreeBSD'
        }
      }
    end

    # manage_nodejs_package
    context 'and manage_nodejs_package set to true' do
      let :params do
        {
          manage_nodejs_package: true
        }
      end

      it 'the nodejs package resource should be present' do
        is_expected.to contain_package('www/node')
      end
    end

    context 'and manage_nodejs_package set to false' do
      let :params do
        {
          manage_nodejs_package: false
        }
      end

      it 'the nodejs and dev package resources should not be present' do
        is_expected.not_to contain_package('www/node')
        is_expected.not_to contain_package('www/node-devel')
      end
    end

    # nodejs_dev_package_ensure
    context 'with nodejs_dev_package_ensure set to installed' do
      let :params do
        {
          nodejs_dev_package_ensure: 'installed'
        }
      end

      it 'the nodejs development package should be installed' do
        is_expected.to contain_package('www/node-devel').with('ensure' => 'installed')
      end
    end

    context 'with nodejs_dev_package_ensure set to absent' do
      let :params do
        {
          nodejs_dev_package_ensure: 'absent'
        }
      end

      it 'the nodejs development package should not be present' do
        is_expected.to contain_package('www/node-devel').with('ensure' => 'absent')
      end
    end

    # nodejs_package_ensure
    context 'with nodejs_package_ensure set to installed' do
      let :params do
        {
          nodejs_package_ensure: 'installed'
        }
      end

      it 'the nodejs package should be present' do
        is_expected.to contain_package('www/node').with('ensure' => 'installed')
      end
    end

    context 'with nodejs_package_ensure set to absent' do
      let :params do
        {
          nodejs_package_ensure: 'absent'
        }
      end

      it 'the nodejs package should be absent' do
        is_expected.to contain_package('www/node').with('ensure' => 'absent')
      end
    end

    # npm_package_ensure
    context 'with npm_package_ensure set to installed' do
      let :params do
        {
          npm_package_ensure: 'installed'
        }
      end

      it 'the npm package should be present' do
        is_expected.to contain_package('www/npm').with('ensure' => 'installed')
      end
    end

    context 'with npm_package_ensure set to absent' do
      let :params do
        {
          npm_package_ensure: 'absent'
        }
      end

      it 'the npm package should be absent' do
        is_expected.to contain_package('www/npm').with('ensure' => 'absent')
      end
    end
  end

  context 'when running on OpenBSD' do
    let :facts do
      {
        'os' => {
          'family' => 'OpenBSD',
          'name' => 'OpenBSD'
        }
      }
    end

    # manage_nodejs_package
    context 'and manage_nodejs_package set to true' do
      let :params do
        {
          manage_nodejs_package: true
        }
      end

      it 'the nodejs package resource should be present' do
        is_expected.to contain_package('node')
      end
    end

    context 'and manage_nodejs_package set to false' do
      let :params do
        {
          manage_nodejs_package: false
        }
      end

      it 'the nodejs package resource should not be present' do
        is_expected.not_to contain_package('node')
      end
    end

    # nodejs_package_ensure
    context 'with nodejs_package_ensure set to installed' do
      let :params do
        {
          nodejs_package_ensure: 'installed'
        }
      end

      it 'the nodejs package should be present' do
        is_expected.to contain_package('node').with('ensure' => 'installed')
      end
    end

    context 'with nodejs_package_ensure set to absent' do
      let :params do
        {
          nodejs_package_ensure: 'absent'
        }
      end

      it 'the nodejs package should be absent' do
        is_expected.to contain_package('node').with('ensure' => 'absent')
      end
    end
  end

  context 'when running on Darwin' do
    let :facts do
      {
        'os' => {
          'family' => 'Darwin',
          'name' => 'Darwin'
        }
      }
    end

    # manage_nodejs_package
    context 'and manage_nodejs_package set to true' do
      let :params do
        {
          manage_nodejs_package: true
        }
      end

      it 'the nodejs package resource should be present' do
        is_expected.to contain_package('nodejs')
      end
    end

    context 'and manage_nodejs_package set to false' do
      let :params do
        {
          manage_nodejs_package: false
        }
      end

      it 'the nodejs and dev package resources should not be present' do
        is_expected.not_to contain_package('nodejs')
        is_expected.not_to contain_package('nodejs-devel')
      end
    end

    # nodejs_dev_package_ensure
    context 'with nodejs_dev_package_ensure set to installed' do
      let :params do
        {
          nodejs_dev_package_ensure: 'installed'
        }
      end

      it 'the nodejs development package should be installed' do
        is_expected.to contain_package('nodejs-devel').with('ensure' => 'installed')
      end
    end

    context 'with nodejs_dev_package_ensure set to absent' do
      let :params do
        {
          nodejs_dev_package_ensure: 'absent'
        }
      end

      it 'the nodejs development package should not be present' do
        is_expected.to contain_package('nodejs-devel').with('ensure' => 'absent')
      end
    end

    # nodejs_package_ensure
    context 'with nodejs_package_ensure set to installed' do
      let :params do
        {
          nodejs_package_ensure: 'installed'
        }
      end

      it 'the nodejs package should be present' do
        is_expected.to contain_package('nodejs').with('ensure' => 'installed')
      end
    end

    context 'with nodejs_package_ensure set to absent' do
      let :params do
        {
          nodejs_package_ensure: 'absent'
        }
      end

      it 'the nodejs package should be absent' do
        is_expected.to contain_package('nodejs').with('ensure' => 'absent')
      end
    end

    # npm_package_ensure
    context 'with npm_package_ensure set to installed' do
      let :params do
        {
          npm_package_ensure: 'installed'
        }
      end

      it 'the npm package should be present' do
        is_expected.to contain_package('npm').with('ensure' => 'installed')
      end
    end

    context 'with npm_package_ensure set to absent' do
      let :params do
        {
          npm_package_ensure: 'absent'
        }
      end

      it 'the npm package should be absent' do
        is_expected.to contain_package('npm').with('ensure' => 'absent')
      end
    end

    context 'with the package_provider left as default' do
      it 'uses Macports as the default provider' do
        is_expected.to contain_package('nodejs').with('provider' => 'macports')
      end
    end

    context 'with the package_provider set to homebrew' do
      let :params do
        {
          package_provider: 'homebrew'
        }
      end

      it 'uses homebrew as the default provider' do
        is_expected.to contain_package('nodejs').with('provider' => 'homebrew')
      end
    end
  end

  context 'when running on Windows' do
    let :facts do
      {
        'os' => {
          'family' => 'Windows',
          'name' => 'Windows',
          'windows' => {
            'system32' => 'C:\Windows\system32'
          }
        }
      }
    end

    # manage_nodejs_package
    context 'and manage_nodejs_package set to true' do
      let :params do
        {
          manage_nodejs_package: true
        }
      end

      it 'the nodejs package resource should be present' do
        is_expected.to contain_package('nodejs')
      end
    end

    context 'and manage_nodejs_package set to false' do
      let :params do
        {
          manage_nodejs_package: false
        }
      end

      it 'the nodejs package resource should not be present' do
        is_expected.not_to contain_package('nodejs')
      end
    end

    # nodejs_package_ensure
    context 'with nodejs_package_ensure set to installed' do
      let :params do
        {
          nodejs_package_ensure: 'installed'
        }
      end

      it 'the nodejs package should be present' do
        is_expected.to contain_package('nodejs').with('ensure' => 'installed')
      end
    end

    context 'with nodejs_package_ensure set to absent' do
      let :params do
        {
          nodejs_package_ensure: 'absent'
        }
      end

      it 'the nodejs package should be absent' do
        is_expected.to contain_package('nodejs').with('ensure' => 'absent')
      end
    end

    # npm_package_ensure
    context 'with npm_package_ensure set to installed' do
      let :params do
        {
          npm_package_ensure: 'installed'
        }
      end

      it 'the npm package should be present' do
        is_expected.to contain_package('npm').with('ensure' => 'installed')
      end
    end

    context 'with npm_package_ensure set to absent' do
      let :params do
        {
          npm_package_ensure: 'absent'
        }
      end

      it 'the npm package should be absent' do
        is_expected.to contain_package('npm').with('ensure' => 'absent')
      end
    end
  end

  context 'when running on Gentoo' do
    let :facts do
      {
        'os' => {
          'family' => 'Gentoo',
          'name' => 'Gentoo'
        }
      }
    end

    # manage_nodejs_package
    context 'and manage_nodejs_package set to true' do
      let :params do
        {
          manage_nodejs_package: true
        }
      end

      it 'the nodejs package resource should be present' do
        is_expected.to contain_package('net-libs/nodejs')
      end
    end

    context 'and manage_nodejs_package set to false' do
      let :params do
        {
          manage_nodejs_package: false
        }
      end

      it 'the nodejs package resource should not be present' do
        is_expected.not_to contain_package('net-libs/nodejs')
      end
    end

    # nodejs_package_ensure
    context 'with nodejs_package_ensure set to installed' do
      let :params do
        {
          nodejs_package_ensure: 'installed'
        }
      end

      it 'the nodejs package should be present' do
        is_expected.to contain_package('net-libs/nodejs').with('ensure' => 'installed')
      end
    end

    context 'with nodejs_package_ensure set to absent' do
      let :params do
        {
          nodejs_package_ensure: 'absent'
        }
      end

      it 'the nodejs package should be absent' do
        is_expected.to contain_package('net-libs/nodejs').with('ensure' => 'absent')
      end
    end

    context 'with use_flags set to npm, snapshot' do
      let :params do
        {
          use_flags: %w[npm snapshot]
        }
      end

      it 'the nodejs package should have npm, snapshot use flags' do
        is_expected.to contain_package_use('net-libs/nodejs').with('use' => %w[npm snapshot])
      end
    end
  end

  context 'when running on Amazon Linux 2015.03' do
    let :facts do
      {
        'os' => {
          'family' => 'RedHat',
          'name' => 'Amazon',
          'release' => {
            'full' => '2015.03',
            'major' => '2015',
            'minor' => '03'
          }
        }
      }
    end

    repo_baseurl        = 'https://rpm.nodesource.com/pub_20.x/nodistro/nodejs/$basearch'
    repo_descr          = 'Node.js Packages - $basearch'

    # manage_package_repo
    context 'with manage_package_repo set to true' do
      let :default_params do
        {
          manage_package_repo: true
        }
      end

      context 'and manage_nodejs_package set to true' do
        let :params do
          default_params.merge!(manage_nodejs_package: true)
        end

        it 'the nodejs package resource should be present' do
          is_expected.to contain_package('nodejs')
        end
      end

      context 'and manage_nodejs_package set to false' do
        let :params do
          default_params.merge!(manage_nodejs_package: false)
        end

        it 'the nodejs and dev package resources should not be present' do
          is_expected.not_to contain_package('nodejs')
          is_expected.not_to contain_package('nodejs-devel')
        end
      end

      context 'and repo_class set to nodejs::repo::nodesource' do
        let :params do
          default_params.merge!(repo_class: 'nodejs::repo::nodesource')
        end

        it 'nodejs::repo::nodesource should be in the catalog' do
          is_expected.to contain_class('nodejs::repo::nodesource')
        end

        it 'nodejs::repo::nodesource::yum should be in the catalog' do
          is_expected.to contain_class('nodejs::repo::nodesource::yum')
        end

        it 'the nodesource repo should contain the right description and baseurl' do
          is_expected.to contain_yumrepo('nodesource').with('baseurl' => repo_baseurl,
                                                            'descr' => repo_descr)
        end
      end

      context 'and repo_ensure set to present' do
        let :params do
          default_params.merge!(repo_ensure: 'present')
        end

        it 'the nodesource yum repo files should exist' do
          is_expected.to contain_yumrepo('nodesource')
        end
      end

      context 'and repo_ensure set to absent' do
        let :params do
          default_params.merge!(repo_ensure: 'absent')
        end

        it 'the nodesource yum repo files should not exist' do
          is_expected.to contain_yumrepo('nodesource').with('ensure' => 'absent')
        end
      end

      context 'and repo_proxy set to absent' do
        let :params do
          default_params.merge!(repo_proxy: 'absent')
        end

        it 'the yumrepo resource should contain proxy = absent' do
          is_expected.to contain_yumrepo('nodesource').with('proxy' => 'absent')
        end
      end

      context 'and repo_proxy set to http://proxy.localdomain.com' do
        let :params do
          default_params.merge!(repo_proxy: 'http://proxy.localdomain.com')
        end

        it 'the yumrepo resource should contain proxy = http://proxy.localdomain.com' do
          is_expected.to contain_yumrepo('nodesource').with('proxy' => 'http://proxy.localdomain.com')
        end
      end

      context 'and repo_proxy_password set to absent' do
        let :params do
          default_params.merge!(repo_proxy_password: 'absent')
        end

        it 'the yumrepo resource should contain proxy_password = absent' do
          is_expected.to contain_yumrepo('nodesource').with('proxy_password' => 'absent')
        end
      end

      context 'and repo_proxy_password set to password' do
        let :params do
          default_params.merge!(repo_proxy_password: 'password')
        end

        it 'the yumrepo resource should contain proxy_password = password' do
          is_expected.to contain_yumrepo('nodesource').with('proxy_password' => 'password')
        end
      end

      context 'and repo_proxy_username set to absent' do
        let :params do
          default_params.merge!(repo_proxy_username: 'absent')
        end

        it 'the yumrepo resource should contain proxy_username = absent' do
          is_expected.to contain_yumrepo('nodesource').with('proxy_username' => 'absent')
        end
      end

      context 'and repo_proxy_username set to proxyuser' do
        let :params do
          default_params.merge!(repo_proxy_username: 'proxyuser')
        end

        it 'the yumrepo resource should contain proxy_username = proxyuser' do
          is_expected.to contain_yumrepo('nodesource').with('proxy_username' => 'proxyuser')
        end
      end
    end

    context 'with manage_package_repo set to false' do
      let :params do
        {
          manage_package_repo: false
        }
      end

      it 'nodejs::repo::nodesource should not be in the catalog' do
        is_expected.not_to contain_class('nodejs::repo::nodesource')
      end
    end

    # nodejs_debug_package_ensure
    context 'with nodejs_debug_package_ensure set to installed' do
      let :params do
        {
          nodejs_debug_package_ensure: 'installed'
        }
      end

      it 'the nodejs package with debugging symbols should be installed' do
        is_expected.to contain_package('nodejs-debuginfo').with('ensure' => 'installed')
      end
    end

    context 'with nodejs_debug_package_ensure set to absent' do
      let :params do
        {
          nodejs_debug_package_ensure: 'absent'
        }
      end

      it 'the nodejs package with debugging symbols should not be present' do
        is_expected.to contain_package('nodejs-debuginfo').with('ensure' => 'absent')
      end
    end

    # nodejs_dev_package_ensure
    context 'with nodejs_dev_package_ensure set to installed' do
      let :params do
        {
          nodejs_dev_package_ensure: 'installed'
        }
      end

      it 'the nodejs development package should be installed' do
        is_expected.to contain_package('nodejs-devel').with('ensure' => 'installed')
      end
    end

    context 'with nodejs_dev_package_ensure set to absent' do
      let :params do
        {
          nodejs_dev_package_ensure: 'absent'
        }
      end

      it 'the nodejs development package should not be present' do
        is_expected.to contain_package('nodejs-devel').with('ensure' => 'absent')
      end
    end

    # nodejs_package_ensure
    context 'with nodejs_package_ensure set to installed' do
      let :params do
        {
          nodejs_package_ensure: 'installed'
        }
      end

      it 'the nodejs package should be present' do
        is_expected.to contain_package('nodejs').with('ensure' => 'installed')
      end
    end

    context 'with nodejs_package_ensure set to absent' do
      let :params do
        {
          nodejs_package_ensure: 'absent'
        }
      end

      it 'the nodejs package should be absent' do
        is_expected.to contain_package('nodejs').with('ensure' => 'absent')
      end
    end

    # npm_package_ensure
    context 'with npm_package_ensure set to installed' do
      let :params do
        {
          npm_package_ensure: 'installed'
        }
      end

      it 'the npm package should be present' do
        is_expected.to contain_package('npm').with('ensure' => 'installed')
      end
    end

    context 'with npm_package_ensure set to absent' do
      let :params do
        {
          npm_package_ensure: 'absent'
        }
      end

      it 'the npm package should be absent' do
        is_expected.to contain_package('npm').with('ensure' => 'absent')
      end
    end
  end
end
