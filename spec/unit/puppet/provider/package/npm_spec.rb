# frozen_string_literal: true

require 'spec_helper'

describe Puppet::Type.type(:package).provider(:npm) do
  let(:resource) do
    Puppet::Type.type(:package).new(
      name: 'express',
      ensure: :present
    )
  end

  let(:provider) do
    provider = described_class.new(resource)
    provider.resource = resource
    provider
  end

  before do
    allow(provider.class).to receive(:command).with(:npm).and_return('/usr/local/bin/npm')
    resource.provider = provider
  end

  def self.it_should_respond_to(*actions)
    actions.each do |action|
      it "responds to :#{action}" do
        expect(provider).to respond_to(action)
      end
    end
  end

  it_should_respond_to :install, :uninstall, :update, :query, :latest

  describe 'when installing npm packages' do
    it 'uses package name by default' do
      expect(provider).to receive(:npm).with('install', '--global', 'express')
      provider.install
    end

    it 'uses the source instead of the package name' do
      resource[:source] = '/tmp/express.tar.gz'
      expect(provider).to receive(:npm).with('install', '--global', '/tmp/express.tar.gz')
      provider.install
    end

    it 'passes the install_options to npm' do
      resource[:install_options] = ['--verbose']
      expect(provider).to receive(:npm).with('install', '--global', '--verbose', 'express')
      provider.install
    end
  end

  describe 'and install_options is a hash' do
    it 'passes the install_options to npm' do
      resource[:install_options] = [{ '--loglevel' => 'error' }]
      expect(provider).to receive(:npm).with('install', '--global', '--loglevel=error', 'express')
      provider.install
    end
  end

  describe 'when npm packages are installed globally' do
    before do
      provider.class.instance_variable_set(:@npmlist, nil)
    end

    it 'returns a list of npm packages installed globally' do
      expect(provider.class).to receive(:execute).
        with(['/usr/local/bin/npm', 'list', '--json', '--global'], anything).
        and_return(Puppet::Util::Execution::ProcessOutput.new(File.read('spec/fixtures/unit/puppet/provider/package/npm/npm_global'), 0))
      expect(provider.class.instances.map(&:properties).sort_by { |res| res[:name] }).to eq([
                                                                                              { ensure: '2.5.9', provider: 'npm', name: 'express' },
                                                                                              { ensure: '1.1.15', provider: 'npm', name: 'npm' }
                                                                                            ])
    end

    it 'logs and continue if the list command has a non-zero exit code' do
      expect(provider.class).to receive(:execute).
        with(['/usr/local/bin/npm', 'list', '--json', '--global'], anything).
        and_return(Puppet::Util::Execution::ProcessOutput.new(File.read('spec/fixtures/unit/puppet/provider/package/npm/npm_global'), 123))
      expect(Puppet).to receive(:debug).with(a_string_matching(%r{123}))
      expect(provider.class.instances.map(&:properties)).not_to eq([])
    end

    it "logs and return no packages if JSON isn't output" do
      expect(provider.class).to receive(:execute).
        with(['/usr/local/bin/npm', 'list', '--json', '--global'], anything).
        and_return(Puppet::Util::Execution::ProcessOutput.new('failure!', 0))
      expect(Puppet).to receive(:debug).with(a_string_matching(%r{npm list.*failure!}))
      expect(provider.class.instances).to eq([])
    end
  end

  describe '#latest' do
    it 'filters npm registry logging' do
      expect(provider).to receive(:npm).with('view', 'express', 'version').and_return("npm http GET https://registry.npmjs.org/express\nnpm http 200 https://registry.npmjs.org/express\n2.0.0")
      expect(provider.latest).to eq('2.0.0')
    end
  end
end
