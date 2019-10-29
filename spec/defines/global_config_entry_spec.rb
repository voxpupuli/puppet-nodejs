require 'spec_helper'

describe 'nodejs::npm::global_config_entry', type: :define do
  let :pre_condition do
    'class { "nodejs": }'
  end

  on_supported_os.each do |os, facts|
    context "on #{os} " do
      let :facts do
        facts
      end

      context 'with name set to proxy and value set to proxy.domain' do
        let(:title) { 'proxy' }
        let :params do
          {
            value: 'proxy.domain'
          }
        end

        it 'npm config set proxy proxy.domain should be executed' do
          is_expected.to contain_exec('npm_config present proxy').with('command' => '/usr/bin/npm config set proxy proxy.domain --global')
        end
      end

      context 'with name set to https-proxy and value set to proxy.domain' do
        let(:title) { 'https-proxy' }
        let :params do
          {
            value: 'proxy.domain'
          }
        end

        it 'npm config set https-proxy proxy.domain should be executed' do
          is_expected.to contain_exec('npm_config present https-proxy').with('command' => '/usr/bin/npm config set https-proxy proxy.domain --global')
        end
      end

      context 'with name set to color and ensure set to absent' do
        let(:title) { 'color' }
        let :params do
          {
            ensure: 'absent'
          }
        end

        it 'npm config delete color should be executed' do
          is_expected.to contain_exec('npm_config absent color').with('command' => '/usr/bin/npm config delete color --global')
        end
      end

      context 'with name set to :_secret and ensure set to present' do
        let(:title) { '//path.to.registry/:_secret' }
        let :params do
          {
            value: 'cGFzc3dvcmQ=',
            ensure: 'present'
          }
        end

        it 'npm config set :_secret should be executed' do
          is_expected.to contain_exec('npm_config present //path.to.registry/:_secret').with('command' => '/usr/bin/npm config set //path.to.registry/:_secret cGFzc3dvcmQ= --global')
        end
      end

      context 'with ensure npm package set to present' do
        let(:pre_condition) do
          <<-PUPPET
            class { 'nodejs':
              nodejs_package_name => 'node-package-name',
              npm_package_name    => 'npm-package-name',
              npm_package_ensure  => present,
            }
          PUPPET
        end
        let(:title) { 'prefer-online' }
        let :params do
          {
            value: 'true'
          }
        end

        it 'npm config set prefer-online should be executed and require npm package' do
          is_expected.to contain_exec('npm_config present prefer-online').with('command' => '/usr/bin/npm config set prefer-online true --global').that_requires('Package[npm-package-name]')
        end

        it 'npm config set prefer-online should not require node package' do
          is_expected.not_to contain_exec('npm_config present prefer-online').with('command' => '/usr/bin/npm config set prefer-online true --global').that_requires('Package[node-package-name]')
        end
      end

      context 'with ensure npm package set to absent and repo class set to nodesource' do
        let(:pre_condition) do
          <<-PUPPET
            class { 'nodejs':
              nodejs_package_name => 'node-package-name',
              npm_package_ensure  => absent,
              repo_class          => '::nodejs::repo::nodesource',
            }
          PUPPET
        end
        let(:title) { 'loglevel' }
        let :params do
          {
            value: 'debug'
          }
        end

        it 'npm config set loglevel should be executed and require nodejs package' do
          is_expected.to contain_exec('npm_config present loglevel').with('command' => '/usr/bin/npm config set loglevel debug --global').that_requires('Package[node-package-name]')
        end
      end

      context 'with ensure npm package set to absent and repo class set to something else' do
        let(:pre_condition) do
          <<-PUPPET
            class something_else { }
            class { 'nodejs':
              nodejs_package_name => 'node-package-name',
              npm_package_name    => 'npm-package-name',
              npm_package_ensure  => absent,
              repo_class          => '::something_else',
            }
          PUPPET
        end
        let(:title) { 'init-version' }
        let :params do
          {
            value: '0.0.1'
          }
        end

        it 'npm config set init-version should be executed' do
          is_expected.to contain_exec('npm_config present init-version').with('command' => '/usr/bin/npm config set init-version 0.0.1 --global')
        end

        it 'npm config set init-version should not require npm package' do
          is_expected.not_to contain_exec('npm_config present init-version').with('command' => '/usr/bin/npm config set init-version 0.0.1 --global').that_requires('Package[npm-package-name]')
        end

        it 'npm config set init-version should not require node package' do
          is_expected.not_to contain_exec('npm_config present init-version').with('command' => '/usr/bin/npm config set init-version 0.0.1 --global').that_requires('Package[node-package-name]')
        end
      end
    end
  end
end
