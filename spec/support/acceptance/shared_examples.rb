# frozen_string_literal: true

shared_examples 'cleanup' do
  context 'cleanup' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'nodejs':
          nodejs_debug_package_ensure => purged,
          nodejs_dev_package_ensure   => purged,
          nodejs_package_ensure       => purged,
          npm_package_ensure          => purged,
          repo_ensure                 => absent,
        }
        PUPPET
      end
    end
  end
end
