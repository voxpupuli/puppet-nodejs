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
    end
  end
end
