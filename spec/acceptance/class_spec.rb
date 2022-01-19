# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'nodejs' do
  case fact('os.family')
  when 'RedHat'
    pkg_cmd = 'yum info nodejs | grep "^From repo"'
    install_module_from_forge('puppet-epel', '>= 3.0.0 < 5.0.0')
  when 'Debian'
    pkg_cmd = 'dpkg -s nodejs | grep "^Maintainer"'
    install_module_from_forge('puppetlabs-apt', '>= 4.4.0 < 9.0.0')
  end

  context 'default parameters' do
    let(:pp) { "class { 'nodejs': }" }

    it_behaves_like 'an idempotent resource'

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

  context 'repo_class => epel', if: ((fact('os.family') == 'RedHat') && (fact('os.release.major') != '8')) do
    let(:pp) { "class { 'nodejs': repo_class => '::epel' }" }

    include_examples 'cleanup'

    it_behaves_like 'an idempotent resource'

    describe package('nodejs') do
      it { is_expected.to be_installed }

      it 'comes from the expected source' do
        pending("This won't work until we have CentOS 7.4 because of dependency")
        pkg_output = shell(pkg_cmd)
        expect(pkg_output.stdout).to match 'epel'
      end
    end

    context 'set global_config_entry secret', if: fact('os.family') == 'RedHat' do
      let :pp do
        "class { 'nodejs': }; nodejs::npm::global_config_entry { '//path.to.registry/:_secret': ensure => present, value => 'cGFzc3dvcmQ=', require => Package[nodejs],}"
      end

      it_behaves_like 'an idempotent resource'

      describe package('nodejs') do
        it { is_expected.to be_installed }
      end

      describe 'npm config' do
        it 'contains the global_config_entry secret' do
          npm_output = shell('cat $(/usr/bin/npm config get globalconfig)')
          expect(npm_output.stdout).to match '//path.to.registry/:_secret="cGFzc3dvcmQ="'
        end
      end
    end

    context 'set global_config_entry secret unquoted', if: fact('os.family') == 'RedHat' do
      let :pp do
        "class { 'nodejs': }; nodejs::npm::global_config_entry { '//path.to.registry/:_secret': ensure => present, value => 'cGFzc3dvcmQ', require => Package[nodejs],}"
      end

      it_behaves_like 'an idempotent resource'

      describe package('nodejs') do
        it { is_expected.to be_installed }
      end

      describe 'npm config' do
        it 'contains the global_config_entry secret' do
          npm_output = shell('cat $(/usr/bin/npm config get globalconfig)')
          expect(npm_output.stdout).to match '//path.to.registry/:_secret=cGFzc3dvcmQ'
        end
      end
    end
  end

  context 'native Debian packages' do
    let(:pp) do
      "
    class { 'nodejs':
      manage_package_repo       => false,
      nodejs_dev_package_ensure => present,
      npm_package_ensure        => present,
    }
    "
    end

    include_examples 'cleanup'

    it_behaves_like 'an idempotent resource'

    expected_packages = []

    if fact('os.family') == 'Debian'
      if %w[9 16.04 18.04].include? fact('os.release.major')
        expected_packages << 'nodejs-dev'

        expected_packages << 'npm' if %w[16.04 18.04].include? fact('os.release.major')
      else
        expected_packages << 'libnode-dev'

        expected_packages << 'npm'
      end

      expected_packages.each do |pkg|
        describe package(pkg) do
          it { is_expected.to be_installed }
        end
      end
    end
  end
end
