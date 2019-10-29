require 'beaker-rspec'
require 'beaker-puppet'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'

RSpec.configure do |c|
  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    install_module
    install_module_dependencies

    # Additional modules for soft deps
    hosts.each do |host|
      case fact_on(host, 'os.family')
      when 'Debian'
        install_module_from_forge_on(host, 'puppetlabs-apt', '>= 4.4.0 < 8.0.0')
      when 'RedHat'
        install_module_from_forge_on(host, 'stahnma-epel', '>= 1.2.0 < 2.0.0')
      end
    end
  end
end

shared_examples 'an idempotent resource' do
  it 'applies with no errors' do
    apply_manifest(pp, catch_failures: true)
  end

  it 'applies a second time without changes' do
    apply_manifest(pp, catch_changes: true)
  end
end
