require 'spec_helper'

describe 'nodejs', :type => :class do

  describe 'when deploying on debian' do
    let :facts do
      {
        :operatingsystem => 'Debian',
        :lsbdistcodename => 'sid',
      }
    end

    it { should contain_class('apt') }
    it { should contain_apt__source('sid').with({
      'location' => 'http://ftp.us.debian.org/debian/',
    }) }
    it { should contain_package('nodejs') }
  end

  describe 'when deploying on ubuntu' do
    let :facts do
      {
        :operatingsystem => 'Ubuntu',
        :lsbdistcodename => 'edgy',
      }
    end

    it { should contain_class('apt') }
    it { should contain_apt__ppa('ppa:chris-lea/node.js') }
    it { should contain_package('nodejs') }
  end

  describe 'when deploying on RedHat' do
    let :facts do
      {
        :operatingsystem => 'RedHat',
      }
    end

    it { expect { should contain_package('nodejs') }.to raise_error(Puppet::Error) }
  end
end

