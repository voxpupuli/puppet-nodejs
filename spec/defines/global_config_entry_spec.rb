# frozen_string_literal: true

require 'spec_helper'

describe 'nodejs::npm::global_config_entry', type: :define do
  let :pre_condition do
    'class { "nodejs": }'
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      let(:fallback_path) do
        npm_binary = (os_facts[:os]['family'] == 'FreeBSD') ? '/usr/local/bin/npm' : '/usr/bin/npm'

        # `<prefix>/etc/npmrc` derived from the npm binary location.
        "#{File.dirname(File.dirname(npm_binary))}/etc/npmrc"
      end

      context 'with name set to proxy and value set to proxy.domain' do
        let(:title) { 'proxy' }
        let :params do
          {
            value: 'proxy.domain',
          }
        end

        it do
          is_expected.to contain_ini_setting('nodejs npm global_config_entry proxy').with(
            ensure: 'present',
            path: fallback_path,
            setting: 'proxy',
            value: 'proxy.domain',
            show_diff: false,
          ).that_requires(['Class[Nodejs]', "Exec[nodejs npm global_config_entry mkdir #{File.dirname(fallback_path)}]"])

          is_expected.to contain_exec("nodejs npm global_config_entry mkdir #{File.dirname(fallback_path)}").with(
            command: ['mkdir', '-p', File.dirname(fallback_path)],
            creates: File.dirname(fallback_path),
          )

          is_expected.not_to contain_file(File.dirname(fallback_path))
        end
      end

      context 'with the npm_globalconfig_path fact available' do
        let(:facts) { os_facts.merge(npm_globalconfig_path: '/custom/npmrc') }
        let(:title) { 'proxy' }
        let :params do
          {
            value: 'proxy.domain',
          }
        end

        it do
          is_expected.to contain_ini_setting('nodejs npm global_config_entry proxy').with(
            path: '/custom/npmrc',
          )
        end
      end

      context 'with config_path set' do
        let(:facts) { os_facts.merge(npm_globalconfig_path: '/custom/npmrc') }
        let(:title) { 'proxy' }
        let :params do
          {
            config_path: '/etc/npmrc',
            value: 'proxy.domain',
          }
        end

        it do
          is_expected.to contain_ini_setting('nodejs npm global_config_entry proxy').with(
            path: '/etc/npmrc',
          )
        end

        it 'never manages the existing parent directory' do
          is_expected.to contain_exec('nodejs npm global_config_entry mkdir /etc').with(
            creates: '/etc',
          )
          is_expected.not_to contain_file('/etc')
        end
      end

      context 'with name set to https-proxy and value set to proxy.domain' do
        let(:title) { 'https-proxy' }
        let :params do
          {
            value: 'proxy.domain',
          }
        end

        it do
          is_expected.to contain_ini_setting('nodejs npm global_config_entry https-proxy').with(
            ensure: 'present',
            setting: 'https-proxy',
            value: 'proxy.domain',
          )
        end
      end

      context 'with name set to color and ensure set to absent' do
        let(:title) { 'color' }
        let :params do
          {
            ensure: 'absent',
          }
        end

        it do
          is_expected.to contain_ini_setting('nodejs npm global_config_entry color').with(
            ensure: 'absent',
          )

          is_expected.not_to contain_file(File.dirname(fallback_path))
        end
      end

      context 'with name set to :_secret and ensure set to present' do
        let(:title) { '//path.to.registry/:_secret' }
        let :params do
          {
            value: 'cGFzc3dvcmQ=',
            ensure: 'present',
          }
        end

        it do
          is_expected.to contain_ini_setting('nodejs npm global_config_entry //path.to.registry/:_secret').with(
            ensure: 'present',
            setting: '//path.to.registry/:_secret',
            value: 'cGFzc3dvcmQ=',
            show_diff: false,
          )
        end
      end

      context 'with show_diff set to true' do
        let(:title) { 'proxy' }
        let :params do
          {
            show_diff: true,
            value: 'proxy.domain',
          }
        end

        it do
          is_expected.to contain_ini_setting('nodejs npm global_config_entry proxy').with(
            show_diff: true,
          )
        end
      end

      context 'with a boolean value' do
        let(:title) { 'prefer-online' }
        let :params do
          {
            value: true,
          }
        end

        it do
          is_expected.to contain_ini_setting('nodejs npm global_config_entry prefer-online').with(
            value: true,
          )
        end
      end

      context 'with config_path in the root home' do
        let(:title) { 'proxy' }
        let :params do
          {
            config_path: '/root/.npmrc',
            value: 'proxy.domain',
          }
        end

        it { is_expected.to raise_error(Puppet::Error, %r{managed by nodejs::install}) }
      end

      context 'with a relative npm_path' do
        let(:pre_condition) { "class { 'nodejs': npm_path => 'npm' }" }
        let(:title) { 'proxy' }
        let(:params) { { value: 'proxy.domain' } }

        it { is_expected.to raise_error(Puppet::Error, %r{is not an absolute path}) }
      end

      context 'with ensure absent' do
        let(:title) { 'color' }
        let(:params) { { ensure: 'absent' } }

        it { is_expected.not_to contain_exec('nodejs npm global_config_entry mkdir /usr/etc') }
        it { is_expected.to contain_ini_setting('nodejs npm global_config_entry color').that_requires('Class[Nodejs]') }
      end

      context 'with ensure absent and a value' do
        let(:title) { 'color' }
        let(:params) { { ensure: 'absent', value: 'red' } }

        it { is_expected.to raise_error(Puppet::Error, %r{'value' must not be set}) }
      end

      context 'on Windows' do
        let(:facts) { os_facts.merge(os: os_facts[:os].merge(family: 'windows', windows: { system32: 'C:\\Windows\\system32' })) }
        let(:title) { 'proxy' }
        let(:params) { { value: 'proxy.domain' } }

        it { is_expected.to raise_error(Puppet::Error, %r{not supported on Windows}) }
      end

      context 'with ensure present and no value' do
        let(:title) { 'proxy' }
        let :params do
          {
            ensure: 'present',
          }
        end

        it { is_expected.to raise_error(Puppet::Error, %r{'value' is required}) }
      end
    end
  end
end
