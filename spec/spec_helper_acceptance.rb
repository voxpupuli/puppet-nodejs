require 'beaker-rspec'
require 'beaker/puppet_install_helper'

run_puppet_install_helper

UNSUPPORTED_PLATFORMS = %w[AIX Solaris].freeze

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    hosts.each do |host|
      copy_module_to(host, source: proj_root, module_name: 'nodejs')
      on host, puppet('module install puppetlabs-apt --version 2.0.1'), acceptable_exit_codes: [0, 1]
      on host, puppet('module install gentoo-portage --version 2.0.1'), acceptable_exit_codes: [0, 1]
      on host, puppet('module install chocolatey-chocolatey --version 0.5.2'), acceptable_exit_codes: [0, 1]
      on host, puppet('module install stahnma-epel --version 1.0.0'), acceptable_exit_codes: [0, 1]
      on host, puppet('module install treydock-gpg_key --version 0.0.3'), acceptable_exit_codes: [0, 1]
    end
  end
end
