require 'spec_helper_acceptance'

describe 'nodejs class:' do
  case fact('os.family')
  when 'RedHat'
    pkg_cmd = 'yum info nodejs | grep "^From repo"'
  when 'Debian'
    pkg_cmd = 'dpkg -s nodejs | grep ^Maintainer'
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
end
