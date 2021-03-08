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
            ensure: 'present',
            value: 'proxy.domain',
          }
        end

        it do
          is_expected.to contain_ini_setting(title).with(
            ensure: params[:ensure],
            setting: title,
            value: params[:value],
          )
        end
      end

      context 'with name set to https-proxy and value set to proxy.domain' do
        let(:title) { 'https-proxy' }
        let :params do
          {
            ensure: 'present',
            value: 'proxy.domain'
          }
        end

        it do
          is_expected.to contain_ini_setting(title).with(
            ensure: params[:ensure],
            setting: title,
            value: params[:value],
          )
        end
      end

      context 'with name set to color and ensure set to absent' do
        let(:title) { 'color' }
        let :params do
          {
            ensure: 'absent'
          }
        end

        it do
          is_expected.to contain_ini_setting(title).with(
            ensure: params[:ensure],
            setting: title,
          )
        end
      end

      context 'with name set to :_secret and ensure set to present' do
        let(:title) { '//path.to.registry/:_secret' }
        let :params do
          {
            ensure: 'present',
            value: 'cGFzc3dvcmQ=',
          }
        end

        it do
          is_expected.to contain_ini_setting(title).with(
            ensure: params[:ensure],
            setting: title,
            value: params[:value],
          )
        end
      end
    end
  end
end
