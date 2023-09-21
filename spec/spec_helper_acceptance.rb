# frozen_string_literal: true

require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  case fact('os.family')
  when 'Debian'
    install_puppet_module_via_pmt_on(host, 'puppetlabs-apt')
  when 'RedHat'
    install_puppet_module_via_pmt_on(host, 'puppet-epel')
  end
end

Dir['./spec/support/acceptance/**/*.rb'].sort.each { |f| require f }
