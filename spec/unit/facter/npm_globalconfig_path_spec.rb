# frozen_string_literal: true

require 'spec_helper'
require File.expand_path('../../../lib/facter/npm_globalconfig_path.rb', __dir__)

describe 'npm_globalconfig_path' do
  subject(:fact) { Facter.fact(:npm_globalconfig_path) }

  after { Facter.clear }

  context 'when npm is installed' do
    before do
      allow(Facter::Core::Execution).to receive(:which).with('npm').and_return('/usr/bin/npm')
      allow(Facter::Core::Execution).to receive(:execute).with('npm config get globalconfig', on_fail: nil, timeout: 10).and_return("/usr/etc/npmrc\n")
    end

    it { expect(fact.value).to eq('/usr/etc/npmrc') }
  end

  context 'when npm is not installed' do
    before do
      allow(Facter::Core::Execution).to receive(:which).with('npm').and_return(nil)
    end

    it 'does not execute npm' do
      expect(Facter::Core::Execution).not_to receive(:execute)

      expect(fact.value).to be_nil
    end
  end

  context 'when npm does not report a global config path' do
    before do
      allow(Facter::Core::Execution).to receive(:which).with('npm').and_return('/usr/bin/npm')
      allow(Facter::Core::Execution).to receive(:execute).with('npm config get globalconfig', on_fail: nil, timeout: 10).and_return("\n")
    end

    it { expect(fact.value).to be_nil }
  end
end
