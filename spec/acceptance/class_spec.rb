# frozen_string_literal: true

require 'spec_helper_acceptance'

def nodesource_unsupported(nodejs_version)
  return unless fact('os.family') == 'RedHat'
  return 'Only NodeJS 16 is supported on EL7' if nodejs_version != '16' && fact('os.release.major') == '7'
  return 'NodeJS 16 is not supported on EL9' if nodejs_version == '16' && fact('os.release.major') == '9'
end

describe 'nodejs' do
  case fact('os.family')
  when 'RedHat'
    pkg_cmd = 'yum info nodejs | grep "^From repo"'
  when 'Debian'
    pkg_cmd = 'dpkg -s nodejs | grep "^Maintainer"'
  end

  nodejs_version = ENV.fetch('BEAKER_FACTER_nodejs_version', '20')

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

  context "explicitly using version #{nodejs_version} from nodesource", if: %w[RedHat Debian].include?(fact('os.family')), skip: nodesource_unsupported(nodejs_version) do
    # Only nodejs 16 is supported on EL7 by nodesource

    include_examples 'cleanup'

    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'nodejs':
          repo_version => '#{nodejs_version}',
        }
        PUPPET
      end
    end

    describe package('nodejs') do
      it { is_expected.to be_installed }

      it 'comes from the expected source' do
        pkg_output = shell(pkg_cmd)
        expect(pkg_output.stdout).to match 'nodesource'
      end
    end

    describe command('node --version') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match(%r{^v#{nodejs_version}}) }
    end
  end

  context 'RedHat with repo_class => epel', if: fact('os.family') == 'RedHat' do
    include_examples 'cleanup'

    it_behaves_like 'an idempotent resource' do
      # nodejs-devel (from EPEL) is currently not installable alongside nodejs
      # (from appstream) due to differing versions.
      nodejs_dev_package_ensure =
        if fact('os.release.major') == '9'
          'undef'
        else
          'installed'
        end

      let(:manifest) do
        <<-PUPPET
        class { 'nodejs':
          nodejs_dev_package_ensure => #{nodejs_dev_package_ensure},
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
        it do
          pending('nodejs-devel and nodejs not installable together on EL9') if fact('os.release.major') == '9' && pkg == 'nodejs-devel'
          is_expected.to be_installed
        end
      end
    end
  end

  context 'RedHat with repo_class => nodejs::repo::dnfmodule', if: fact('os.family') == 'RedHat' && %w[8 9].include?(fact('os.release.major')), skip: (nodejs_version == '16' && fact('os.release.major') == '9' ? 'NodeJS 16 is not available on EL9' : nil) do
    # Node 16 is not available on EL9

    include_examples 'cleanup'

    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'nodejs':
          nodejs_dev_package_ensure => installed,
          npm_package_ensure        => installed,
          repo_class                => 'nodejs::repo::dnfmodule',
          repo_version              => '#{nodejs_version}',
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
        it do
          is_expected.to be_installed
        end

        it 'comes from the expected source' do
          pkg_output = shell(pkg_cmd)
          expect(pkg_output.stdout).to match 'appstream'
        end
      end
    end

    describe command('node --version') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match(%r{^v#{nodejs_version}}) }
    end
  end

  context 'Debian distribution packages', if: fact('os.family') == 'Debian' do
    before(:context) { purge_node }

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
    before(:context) { purge_node }

    include_examples 'cleanup'

    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'nodejs': }
        nodejs::npm::global_config_entry { '//path.to.registry/:_authToken':
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
        expect(npm_output.stdout).to match '//path.to.registry/:_authToken="cGFzc3dvcmQ="'
      end
    end
  end

  context 'set global_config_entry secret unquoted' do
    before(:context) { purge_node }

    include_examples 'cleanup'

    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'nodejs': }
        nodejs::npm::global_config_entry { '//path.to.registry/:_authToken':
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
        expect(npm_output.stdout).to match '//path.to.registry/:_authToken=cGFzc3dvcmQ'
      end
    end
  end
end
