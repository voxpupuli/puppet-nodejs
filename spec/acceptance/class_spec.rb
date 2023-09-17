# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'nodejs' do
  case fact('os.family')
  when 'RedHat'
    pkg_cmd = 'yum info nodejs | grep "^From repo"'
    install_module_from_forge('puppet-epel', '>= 3.0.0 < 4.0.0')
  when 'Debian'
    pkg_cmd = 'dpkg -s nodejs | grep "^Maintainer"'
    install_module_from_forge('puppetlabs-apt', '>= 4.4.0 < 9.0.0')
  end

  context 'default parameters' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) { "class { 'nodejs': }" }
    end

    if %w[RedHat Debian].include? fact('os.family')
      describe package('nodejs') do
        it { is_expected.to be_installed }

        it 'comes from the expected source' do
          pkg_output = shell(pkg_cmd)
          expect(pkg_output.stdout).to match 'nodesource'
        end
      end
    end
  end

  context 'RedHat with repo_class => epel', if: fact('os.family') == 'RedHat' do
    include_examples 'cleanup'

    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'nodejs':
          nodejs_dev_package_ensure => installed,
          npm_package_ensure        => installed,
          repo_class                => 'epel',
        }
        PUPPET
      end
    end

    %w[
      npm
      nodejs
      nodejs-devel
    ].each do |pkg|
      describe package(pkg) do
        it { is_expected.to be_installed }
      end
    end
  end

  context 'Debian distribution packages', if: fact('os.family') == 'Debian' do
    include_examples 'cleanup'

    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'nodejs':
          manage_package_repo       => false,
          nodejs_dev_package_ensure => installed,
          npm_package_ensure        => installed,
        }
        PUPPET
      end
    end

    %w[
      libnode-dev
      npm
    ].each do |pkg|
      describe package(pkg) do
        it { is_expected.to be_installed }
      end
    end
  end

  context 'set global_config_entry secret' do
    include_examples 'cleanup'

    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'nodejs': }
        nodejs::npm::global_config_entry { '//path.to.registry/:_secret':
          ensure  => present,
          value   => 'cGFzc3dvcmQ=',
          require => Package[nodejs],
        }
        PUPPET
      end
    end

    describe 'npm config' do
      it 'contains the global_config_entry secret' do
        npm_output = shell('cat $(/usr/bin/npm config get globalconfig)')
        expect(npm_output.stdout).to match '//path.to.registry/:_secret="cGFzc3dvcmQ="'
      end
    end
  end

  context 'set global_config_entry secret unquoted' do
    include_examples 'cleanup'

    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'nodejs': }
        nodejs::npm::global_config_entry { '//path.to.registry/:_secret':
          ensure  => present,
          value   => 'cGFzc3dvcmQ',
          require => Package[nodejs],
        }
        PUPPET
      end
    end

    describe 'npm config' do
      it 'contains the global_config_entry secret' do
        npm_output = shell('cat $(/usr/bin/npm config get globalconfig)')
        expect(npm_output.stdout).to match '//path.to.registry/:_secret=cGFzc3dvcmQ'
      end
    end
  end
end
