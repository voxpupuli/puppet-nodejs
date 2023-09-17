# frozen_string_literal: true

shared_examples 'cleanup' do
  context 'cleanup' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'nodejs':
          nodejs_debug_package_ensure => absent,
          nodejs_dev_package_ensure   => absent,
          nodejs_package_ensure       => absent,
          npm_package_ensure          => absent,
          repo_ensure                 => absent,
        }
        PUPPET
      end
    end
  end
end
