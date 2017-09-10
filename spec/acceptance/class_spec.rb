require 'spec_helper_acceptance'

describe 'nodejs class:', unless: UNSUPPORTED_PLATFORMS.include?(fact('os.family')) do
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

  context 'repo_class => epel', if: fact('os.family') == 'RedHat' do
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
  end
end
