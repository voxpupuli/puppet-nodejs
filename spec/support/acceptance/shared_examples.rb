# frozen_string_literal: true

shared_examples 'an idempotent resource' do
  it 'applies with no errors' do
    apply_manifest(pp, catch_failures: true)
  end

  it 'applies a second time without changes' do
    apply_manifest(pp, catch_changes: true)
  end
end

shared_examples 'cleanup' do
  context 'cleanup' do
    let(:pp) do
      "
      class { 'nodejs':
        nodejs_debug_package_ensure => absent,
        nodejs_dev_package_ensure   => absent,
        nodejs_package_ensure       => absent,
        npm_package_ensure          => absent,
        repo_ensure                 => absent,
      }
      "
    end

    it_behaves_like 'an idempotent resource'

    shell('yum info nodejs || true')
  end
end
