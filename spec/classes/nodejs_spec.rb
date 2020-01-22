require 'spec_helper'

describe 'nodejs', type: :class do
  on_supported_os.each do |os, facts|
    next unless facts[:os]['family'] == 'Debian'

    context "on #{os} " do
      let :facts do
        facts
      end

      is_supported_debian_version = if facts[:os]['family'] == 'Debian' && %w[8 9 10].include?(facts[:os]['release']['major'])
                                      true
                                    else
                                      false
                                    end

      it 'the file resource root_npmrc should be in the catalog' do
        is_expected.to contain_file('root_npmrc').with(
          'ensure' => 'file',
          'path'    => '/root/.npmrc',
          'owner'   => 'root',
          'group'   => '0',
          'mode'    => '0600'
        )
      end

      context 'with npmrc_auth set to a string' do
        let :params do
          {
            npmrc_auth: 'dXNlcjpwYXNzd29yZA=='
          }
        end

        it { is_expected.to contain_file('root_npmrc').with_content(%r{^_auth="dXNlcjpwYXNzd29yZA=="$}) }
      end

      context 'with npmrc_config set to a hash' do
        let :params do
          {
            npmrc_config: { 'http-proxy' => 'http://localhost:8080/' }
          }
        end

        it { is_expected.to contain_file('root_npmrc').with_content(%r{^http-proxy=http://localhost:8080/$}) }
      end

      # manage_package_repo
      context 'with manage_package_repo set to true' do
        let :default_params do
          {
            manage_package_repo: true
          }
        end

        context 'and repo_class set to ::nodejs::repo::nodesource' do
          let :params do
            default_params.merge!(repo_class: 'nodejs::repo::nodesource')
          end

          it '::nodejs::repo::nodesource should be in the catalog' do
            is_expected.to contain_class('nodejs::repo::nodesource')
          end

          it '::nodejs::repo::nodesource::apt should be in the catalog' do
            is_expected.to contain_class('nodejs::repo::nodesource::apt')
          end
        end

        context 'and repo_enable_src set to true' do
          let :params do
            default_params.merge!(repo_enable_src: true)
          end

          it 'the repo apt::source resource should contain include => { src => true}' do
            is_expected.to contain_apt__source('nodesource').with('include' => { 'src' => true })
          end
        end

        context 'and repo_enable_src set to false' do
          let :params do
            default_params.merge!(repo_enable_src: false)
          end

          it 'the repo apt::source resource should contain include => { src => false}' do
            is_expected.to contain_apt__source('nodesource').with('include' => { 'src' => false })
          end
        end

        context 'and repo_pin set to 10' do
          let :params do
            default_params.merge!(repo_pin: '10')
          end

          it 'the repo apt::source resource should contain pin = 10' do
            is_expected.to contain_apt__source('nodesource').with('pin' => '10')
          end
        end

        context 'and repo_release set to stretch' do
          let :params do
            default_params.merge!(repo_release: 'stretch')
          end

          it 'the repo apt::source resource should contain release = stretch' do
            is_expected.to contain_apt__source('nodesource').with('release' => 'stretch')
          end
        end

        context 'and repo_pin not set' do
          let :params do
            default_params.merge!(repo_pin: :undef)
          end

          it 'the repo apt::source resource should contain pin = undef' do
            is_expected.to contain_apt__source('nodesource').with('pin' => nil)
          end
        end

        context 'and repo_url_suffix set to 9.x' do
          let :params do
            default_params.merge!(repo_url_suffix: '9.x')
          end

          it 'the repo apt::source resource should contain location = https://deb.nodesource.com/node_9.x' do
            is_expected.to contain_apt__source('nodesource').with('location' => 'https://deb.nodesource.com/node_9.x')
          end
        end

        context 'and repo_ensure set to present' do
          let :params do
            default_params.merge!(repo_ensure: 'present')
          end

          it 'the nodesource apt sources file should exist' do
            is_expected.to contain_apt__source('nodesource')
          end
        end

        context 'and repo_ensure set to absent' do
          let :params do
            default_params.merge!(repo_ensure: 'absent')
          end

          it 'the nodesource apt sources file should not exist' do
            is_expected.to contain_apt__source('nodesource').with('ensure' => 'absent')
          end
        end
      end

      context 'with manage_package_repo set to false' do
        let :params do
          {
            manage_package_repo: false
          }
        end

        it '::nodejs::repo::nodesource should not be in the catalog' do
          is_expected.not_to contain_class('::nodejs::repo::nodesource')
        end
      end

      # nodejs_debug_package_ensure
      context 'with nodejs_debug_package_ensure set to present' do
        let :params do
          {
            nodejs_debug_package_ensure: 'present'
          }
        end

        it 'the nodejs package with debugging symbols should be installed' do
          is_expected.to contain_package('nodejs-dbg').with('ensure' => 'present')
        end
      end

      context 'with nodejs_debug_package_ensure set to absent' do
        let :params do
          {
            nodejs_debug_package_ensure: 'absent'
          }
        end

        it 'the nodejs package with debugging symbols should not be present' do
          is_expected.to contain_package('nodejs-dbg').with('ensure' => 'absent')
        end
      end

      # nodejs_dev_package_ensure
      context 'with nodejs_dev_package_ensure set to present' do
        let :params do
          {
            nodejs_dev_package_ensure: 'present'
          }
        end

        if is_supported_debian_version

          it 'the nodejs development package resource should not be present' do
            is_expected.not_to contain_package('nodejs-dev')
          end
        else
          it 'the nodejs development package should be installed' do
            is_expected.to contain_package('nodejs-dev').with('ensure' => 'present')
          end
        end
      end

      context 'with nodejs_dev_package_ensure set to absent' do
        let :params do
          {
            nodejs_dev_package_ensure: 'absent'
          }
        end

        if is_supported_debian_version

          it 'the nodejs development package resource should not be present' do
            is_expected.not_to contain_package('nodejs-dev')
          end
        else
          it 'the nodejs development package should not be present' do
            is_expected.to contain_package('nodejs-dev').with('ensure' => 'absent')
          end
        end
      end

      # nodejs_package_ensure
      context 'with nodejs_package_ensure set to present' do
        let :params do
          {
            nodejs_package_ensure: 'present'
          }
        end

        it 'the nodejs package should be present' do
          is_expected.to contain_package('nodejs').with('ensure' => 'present')
        end
      end

      context 'with nodejs_package_ensure set to absent' do
        let :params do
          {
            nodejs_package_ensure: 'absent'
          }
        end

        it 'the nodejs package should be absent' do
          is_expected.to contain_package('nodejs').with('ensure' => 'absent')
        end
      end

      # npm_package_ensure
      context 'with npm_package_ensure set to present' do
        let :params do
          {
            npm_package_ensure: 'present'
          }
        end

        if is_supported_debian_version

          it 'the npm package resource should not be present' do
            is_expected.not_to contain_package('npm')
          end
        else
          it 'the npm package should be present' do
            is_expected.to contain_package('npm').with('ensure' => 'present')
          end
        end
      end

      context 'with npm_package_ensure set to absent' do
        let :params do
          {
            npm_package_ensure: 'absent'
          }
        end

        if is_supported_debian_version

          it 'the npm package resource should not be present' do
            is_expected.not_to contain_package('npm')
          end
        else
          it 'the npm package should be absent' do
            is_expected.to contain_package('npm').with('ensure' => 'absent')
          end
        end
      end

      # npm_package_name
      context 'with npm_package_name set to false' do
        let :params do
          {
            npm_package_name: 'false'
          }
        end

        it 'the npm package resource should not be present' do
          is_expected.not_to contain_package('npm')
        end
      end
    end
  end

  ['6.0', '7.0', '27'].each do |operatingsystemrelease|
    osversions = operatingsystemrelease.split('.')
    operatingsystemmajrelease = osversions[0]

    if operatingsystemrelease =~ %r{^[6-7]\.(\d+)}
      operatingsystem     = 'CentOS'
      dist_type           = 'el'
      repo_baseurl        = "https://rpm.nodesource.com/pub_12.x/#{dist_type}/#{operatingsystemmajrelease}/\$basearch"
      repo_source_baseurl = "https://rpm.nodesource.com/pub_12.x/#{dist_type}/#{operatingsystemmajrelease}/SRPMS"
      repo_descr          = "Node.js Packages for Enterprise Linux #{operatingsystemmajrelease} - \$basearch"
      repo_source_descr   = "Node.js for Enterprise Linux #{operatingsystemmajrelease} - \$basearch - Source"
    else
      operatingsystem     = 'Fedora'
      dist_type           = 'fc'
      repo_baseurl        = "https://rpm.nodesource.com/pub_12.x/#{dist_type}/#{operatingsystemmajrelease}/\$basearch"
      repo_source_baseurl = "https://rpm.nodesource.com/pub_12.x/#{dist_type}/#{operatingsystemmajrelease}/SRPMS"
      repo_descr          = "Node.js Packages for Fedora Core #{operatingsystemmajrelease} - \$basearch"
      repo_source_descr   = "Node.js for Fedora Core #{operatingsystemmajrelease} - \$basearch - Source"
    end

    context "when run on #{operatingsystem} release #{operatingsystemrelease}" do
      let :facts do
        {
          'os' => {
            'family' => 'RedHat',
            'name' => operatingsystem,
            'release' => {
              'major' => operatingsystemmajrelease,
              'full'  => operatingsystemrelease
            }
          }
        }
      end

      # manage_package_repo
      context 'with manage_package_repo set to true' do
        let :default_params do
          {
            manage_package_repo: true
          }
        end

        context 'and repo_class set to ::nodejs::repo::nodesource' do
          let :params do
            default_params.merge!(repo_class: 'nodejs::repo::nodesource')
          end

          it '::nodejs::repo::nodesource should be in the catalog' do
            is_expected.to contain_class('nodejs::repo::nodesource')
          end

          it '::nodejs::repo::nodesource::yum should be in the catalog' do
            is_expected.to contain_class('nodejs::repo::nodesource::yum')
          end

          it 'the nodesource and nodesource-source repos should contain the right description and baseurl' do
            is_expected.to contain_yumrepo('nodesource').with('baseurl' => repo_baseurl,
                                                              'descr'   => repo_descr)

            is_expected.to contain_yumrepo('nodesource-source').with('baseurl' => repo_source_baseurl,
                                                                     'descr'   => repo_source_descr)
          end
        end

        context 'and repo_url_suffix set to 5.x' do
          let :params do
            default_params.merge!(repo_url_suffix: '5.x')
          end

          it "the yum nodesource repo resource should contain baseurl = https://rpm.nodesource.com/pub_5.x/#{dist_type}/#{operatingsystemmajrelease}/\$basearch" do
            is_expected.to contain_yumrepo('nodesource').with('baseurl' => "https://rpm.nodesource.com/pub_5.x/#{dist_type}/#{operatingsystemmajrelease}/\$basearch")
          end
        end

        context 'and repo_enable_src set to true' do
          let :params do
            default_params.merge!(repo_enable_src: true)
          end

          it 'the yumrepo resource nodesource-source should contain enabled = 1' do
            is_expected.to contain_yumrepo('nodesource-source').with('enabled' => '1')
          end
        end

        context 'and repo_enable_src set to false' do
          let :params do
            default_params.merge!(repo_enable_src: false)
          end

          it 'the yumrepo resource should contain enabled = 0' do
            is_expected.to contain_yumrepo('nodesource-source').with('enabled' => '0')
          end
        end

        context 'and repo_priority set to 50' do
          let :params do
            default_params.merge!(repo_priority: '50')
          end

          it 'the yumrepo resource nodesource-source should contain priority = 50' do
            is_expected.to contain_yumrepo('nodesource-source').with('priority' => '50')
          end
        end

        context 'and repo_priority not set' do
          let :params do
            default_params.merge!(repo_priority: 'absent')
          end

          it 'the yumrepo resource nodesource-source should contain priority = absent' do
            is_expected.to contain_yumrepo('nodesource-source').with('priority' => 'absent')
          end
        end

        context 'and repo_ensure set to present' do
          let :params do
            default_params.merge!(repo_ensure: 'present')
          end

          it 'the nodesource yum repo files should exist' do
            is_expected.to contain_yumrepo('nodesource')
            is_expected.to contain_yumrepo('nodesource-source')
          end
        end

        context 'and repo_ensure set to absent' do
          let :params do
            default_params.merge!(repo_ensure: 'absent')
          end

          it 'the nodesource yum repo files should not exist' do
            is_expected.to contain_yumrepo('nodesource').with('ensure' => 'absent')
            is_expected.to contain_yumrepo('nodesource-source').with('ensure' => 'absent')
          end
        end

        context 'and repo_proxy set to absent' do
          let :params do
            default_params.merge!(repo_proxy: 'absent')
          end

          it 'the yumrepo resource should contain proxy = absent' do
            is_expected.to contain_yumrepo('nodesource').with('proxy' => 'absent')
            is_expected.to contain_yumrepo('nodesource-source').with('proxy' => 'absent')
          end
        end

        context 'and repo_proxy set to http://proxy.localdomain.com' do
          let :params do
            default_params.merge!(repo_proxy: 'http://proxy.localdomain.com')
          end

          it 'the yumrepo resource should contain proxy = http://proxy.localdomain.com' do
            is_expected.to contain_yumrepo('nodesource').with('proxy' => 'http://proxy.localdomain.com')
            is_expected.to contain_yumrepo('nodesource-source').with('proxy' => 'http://proxy.localdomain.com')
          end
        end

        context 'and repo_proxy_password set to absent' do
          let :params do
            default_params.merge!(repo_proxy_password: 'absent')
          end

          it 'the yumrepo resource should contain proxy_password = absent' do
            is_expected.to contain_yumrepo('nodesource').with('proxy_password' => 'absent')
            is_expected.to contain_yumrepo('nodesource-source').with('proxy_password' => 'absent')
          end
        end

        context 'and repo_proxy_password set to password' do
          let :params do
            default_params.merge!(repo_proxy_password: 'password')
          end

          it 'the yumrepo resource should contain proxy_password = password' do
            is_expected.to contain_yumrepo('nodesource').with('proxy_password' => 'password')
            is_expected.to contain_yumrepo('nodesource-source').with('proxy_password' => 'password')
          end
        end

        context 'and repo_proxy_username set to absent' do
          let :params do
            default_params.merge!(repo_proxy_username: 'absent')
          end

          it 'the yumrepo resource should contain proxy_username = absent' do
            is_expected.to contain_yumrepo('nodesource').with('proxy_username' => 'absent')
            is_expected.to contain_yumrepo('nodesource-source').with('proxy_username' => 'absent')
          end
        end

        context 'and repo_proxy_username set to proxyuser' do
          let :params do
            default_params.merge!(repo_proxy_username: 'proxyuser')
          end

          it 'the yumrepo resource should contain proxy_username = proxyuser' do
            is_expected.to contain_yumrepo('nodesource').with('proxy_username' => 'proxyuser')
            is_expected.to contain_yumrepo('nodesource-source').with('proxy_username' => 'proxyuser')
          end
        end
      end

      context 'with manage_package_repo set to false' do
        let :params do
          {
            manage_package_repo: false
          }
        end

        it '::nodejs::repo::nodesource should not be in the catalog' do
          is_expected.not_to contain_class('::nodejs::repo::nodesource')
        end
      end

      # nodejs_debug_package_ensure
      context 'with nodejs_debug_package_ensure set to present' do
        let :params do
          {
            nodejs_debug_package_ensure: 'present'
          }
        end

        it 'the nodejs package with debugging symbols should be installed' do
          is_expected.to contain_package('nodejs-debuginfo').with('ensure' => 'present')
        end
      end

      context 'with nodejs_debug_package_ensure set to absent' do
        let :params do
          {
            nodejs_debug_package_ensure: 'absent'
          }
        end

        it 'the nodejs package with debugging symbols should not be present' do
          is_expected.to contain_package('nodejs-debuginfo').with('ensure' => 'absent')
        end
      end

      # nodejs_dev_package_ensure
      context 'with nodejs_dev_package_ensure set to present' do
        let :params do
          {
            nodejs_dev_package_ensure: 'present'
          }
        end

        it 'the nodejs development package should be installed' do
          is_expected.to contain_package('nodejs-devel').with('ensure' => 'present')
        end
      end

      context 'with nodejs_dev_package_ensure set to absent' do
        let :params do
          {
            nodejs_dev_package_ensure: 'absent'
          }
        end

        it 'the nodejs development package should not be present' do
          is_expected.to contain_package('nodejs-devel').with('ensure' => 'absent')
        end
      end

      # nodejs_package_ensure
      context 'with nodejs_package_ensure set to present' do
        let :params do
          {
            nodejs_package_ensure: 'present'
          }
        end

        it 'the nodejs package should be present' do
          is_expected.to contain_package('nodejs').with('ensure' => 'present')
        end
      end

      context 'with nodejs_package_ensure set to absent' do
        let :params do
          {
            nodejs_package_ensure: 'absent'
          }
        end

        it 'the nodejs package should be absent' do
          is_expected.to contain_package('nodejs').with('ensure' => 'absent')
        end
      end

      # npm_package_ensure
      context 'with npm_package_ensure set to present' do
        let :params do
          {
            npm_package_ensure: 'present'
          }
        end

        it 'the npm package should be present' do
          is_expected.to contain_package('npm').with('ensure' => 'present')
        end
      end

      context 'with npm_package_ensure set to absent' do
        let :params do
          {
            npm_package_ensure: 'absent'
          }
        end

        it 'the npm package should be absent' do
          is_expected.to contain_package('npm').with('ensure' => 'absent')
        end
      end
    end
  end

  context 'when running on Suse' do
    let :facts do
      {
        'os' => {
          'family' => 'Suse',
          'name' => 'SLES'
        }
      }
    end

    # nodejs_debug_package_ensure
    context 'with nodejs_debug_package_ensure set to present' do
      let :params do
        {
          nodejs_debug_package_ensure: 'present'
        }
      end

      it 'the nodejs package with debugging symbols should be installed' do
        is_expected.to contain_package('nodejs-debuginfo').with('ensure' => 'present')
      end
    end

    context 'with nodejs_debug_package_ensure set to absent' do
      let :params do
        {
          nodejs_debug_package_ensure: 'absent'
        }
      end

      it 'the nodejs package with debugging symbols should not be present' do
        is_expected.to contain_package('nodejs-debuginfo').with('ensure' => 'absent')
      end
    end

    # nodejs_dev_package_ensure
    context 'with nodejs_dev_package_ensure set to present' do
      let :params do
        {
          nodejs_dev_package_ensure: 'present'
        }
      end

      it 'the nodejs development package should be installed' do
        is_expected.to contain_package('nodejs-devel').with('ensure' => 'present')
      end
    end

    context 'with nodejs_dev_package_ensure set to absent' do
      let :params do
        {
          nodejs_dev_package_ensure: 'absent'
        }
      end

      it 'the nodejs development package should not be present' do
        is_expected.to contain_package('nodejs-devel').with('ensure' => 'absent')
      end
    end

    # nodejs_package_ensure
    context 'with nodejs_package_ensure set to present' do
      let :params do
        {
          nodejs_package_ensure: 'present'
        }
      end

      it 'the nodejs package should be present' do
        is_expected.to contain_package('nodejs').with('ensure' => 'present')
      end
    end

    context 'with nodejs_package_ensure set to absent' do
      let :params do
        {
          nodejs_package_ensure: 'absent'
        }
      end

      it 'the nodejs package should be absent' do
        is_expected.to contain_package('nodejs').with('ensure' => 'absent')
      end
    end

    # npm_package_ensure
    context 'with npm_package_ensure set to present' do
      let :params do
        {
          npm_package_ensure: 'present'
        }
      end

      it 'the npm package should be present' do
        is_expected.to contain_package('npm').with('ensure' => 'present')
      end
    end

    context 'with npm_package_ensure set to absent' do
      let :params do
        {
          npm_package_ensure: 'absent'
        }
      end

      it 'the npm package should be absent' do
        is_expected.to contain_package('npm').with('ensure' => 'absent')
      end
    end
  end

  context 'when running on Archlinux' do
    let :facts do
      {
        'os' => {
          'family' => 'Archlinux',
          'name' => 'Archlinux'
        }
      }
    end

    # nodejs_package_ensure
    context 'with nodejs_package_ensure set to present' do
      let :params do
        {
          nodejs_package_ensure: 'present'
        }
      end

      it 'the nodejs package should be present' do
        is_expected.to contain_package('nodejs').with('ensure' => 'present')
      end
    end

    context 'with nodejs_package_ensure set to absent' do
      let :params do
        {
          nodejs_package_ensure: 'absent'
        }
      end

      it 'the nodejs package should be absent' do
        is_expected.to contain_package('nodejs').with('ensure' => 'absent')
      end
    end
  end

  context 'when running on FreeBSD' do
    let :facts do
      {
        'os' => {
          'family' => 'FreeBSD',
          'name' => 'FreeBSD'
        }
      }
    end

    # nodejs_dev_package_ensure
    context 'with nodejs_dev_package_ensure set to present' do
      let :params do
        {
          nodejs_dev_package_ensure: 'present'
        }
      end

      it 'the nodejs development package should be installed' do
        is_expected.to contain_package('www/node-devel').with('ensure' => 'present')
      end
    end

    context 'with nodejs_dev_package_ensure set to absent' do
      let :params do
        {
          nodejs_dev_package_ensure: 'absent'
        }
      end

      it 'the nodejs development package should not be present' do
        is_expected.to contain_package('www/node-devel').with('ensure' => 'absent')
      end
    end

    # nodejs_package_ensure
    context 'with nodejs_package_ensure set to present' do
      let :params do
        {
          nodejs_package_ensure: 'present'
        }
      end

      it 'the nodejs package should be present' do
        is_expected.to contain_package('www/node').with('ensure' => 'present')
      end
    end

    context 'with nodejs_package_ensure set to absent' do
      let :params do
        {
          nodejs_package_ensure: 'absent'
        }
      end

      it 'the nodejs package should be absent' do
        is_expected.to contain_package('www/node').with('ensure' => 'absent')
      end
    end

    # npm_package_ensure
    context 'with npm_package_ensure set to present' do
      let :params do
        {
          npm_package_ensure: 'present'
        }
      end

      it 'the npm package should be present' do
        is_expected.to contain_package('www/npm').with('ensure' => 'present')
      end
    end

    context 'with npm_package_ensure set to absent' do
      let :params do
        {
          npm_package_ensure: 'absent'
        }
      end

      it 'the npm package should be absent' do
        is_expected.to contain_package('www/npm').with('ensure' => 'absent')
      end
    end
  end

  context 'when running on OpenBSD' do
    let :facts do
      {
        'os' => {
          'family' => 'OpenBSD',
          'name' => 'OpenBSD'
        }
      }
    end

    # nodejs_package_ensure
    context 'with nodejs_package_ensure set to present' do
      let :params do
        {
          nodejs_package_ensure: 'present'
        }
      end

      it 'the nodejs package should be present' do
        is_expected.to contain_package('node').with('ensure' => 'present')
      end
    end

    context 'with nodejs_package_ensure set to absent' do
      let :params do
        {
          nodejs_package_ensure: 'absent'
        }
      end

      it 'the nodejs package should be absent' do
        is_expected.to contain_package('node').with('ensure' => 'absent')
      end
    end
  end

  context 'when running on Darwin' do
    let :facts do
      {
        'os' => {
          'family' => 'Darwin',
          'name' => 'Darwin'
        }
      }
    end

    # nodejs_dev_package_ensure
    context 'with nodejs_dev_package_ensure set to present' do
      let :params do
        {
          nodejs_dev_package_ensure: 'present'
        }
      end

      it 'the nodejs development package should be installed' do
        is_expected.to contain_package('nodejs-devel').with('ensure' => 'present')
      end
    end

    context 'with nodejs_dev_package_ensure set to absent' do
      let :params do
        {
          nodejs_dev_package_ensure: 'absent'
        }
      end

      it 'the nodejs development package should not be present' do
        is_expected.to contain_package('nodejs-devel').with('ensure' => 'absent')
      end
    end

    # nodejs_package_ensure
    context 'with nodejs_package_ensure set to present' do
      let :params do
        {
          nodejs_package_ensure: 'present'
        }
      end

      it 'the nodejs package should be present' do
        is_expected.to contain_package('nodejs').with('ensure' => 'present')
      end
    end

    context 'with nodejs_package_ensure set to absent' do
      let :params do
        {
          nodejs_package_ensure: 'absent'
        }
      end

      it 'the nodejs package should be absent' do
        is_expected.to contain_package('nodejs').with('ensure' => 'absent')
      end
    end

    # npm_package_ensure
    context 'with npm_package_ensure set to present' do
      let :params do
        {
          npm_package_ensure: 'present'
        }
      end

      it 'the npm package should be present' do
        is_expected.to contain_package('npm').with('ensure' => 'present')
      end
    end

    context 'with npm_package_ensure set to absent' do
      let :params do
        {
          npm_package_ensure: 'absent'
        }
      end

      it 'the npm package should be absent' do
        is_expected.to contain_package('npm').with('ensure' => 'absent')
      end
    end

    context 'with the package_provider left as default' do
      it 'uses Macports as the default provider' do
        is_expected.to contain_package('nodejs').with('provider' => 'macports')
      end
    end

    context 'with the package_provider set to homebrew' do
      let :params do
        {
          package_provider: 'homebrew'
        }
      end

      it 'uses homebrew as the default provider' do
        is_expected.to contain_package('nodejs').with('provider' => 'homebrew')
      end
    end
  end

  context 'when running on Windows' do
    let :facts do
      {
        'os' => {
          'family' => 'Windows',
          'name' => 'Windows',
          'windows' => {
            'system32' => 'C:\Windows\system32'
          }
        }
      }
    end

    # nodejs_package_ensure
    context 'with nodejs_package_ensure set to present' do
      let :params do
        {
          nodejs_package_ensure: 'present'
        }
      end

      it 'the nodejs package should be present' do
        is_expected.to contain_package('nodejs').with('ensure' => 'present')
      end
    end

    context 'with nodejs_package_ensure set to absent' do
      let :params do
        {
          nodejs_package_ensure: 'absent'
        }
      end

      it 'the nodejs package should be absent' do
        is_expected.to contain_package('nodejs').with('ensure' => 'absent')
      end
    end

    # npm_package_ensure
    context 'with npm_package_ensure set to present' do
      let :params do
        {
          npm_package_ensure: 'present'
        }
      end

      it 'the npm package should be present' do
        is_expected.to contain_package('npm').with('ensure' => 'present')
      end
    end

    context 'with npm_package_ensure set to absent' do
      let :params do
        {
          npm_package_ensure: 'absent'
        }
      end

      it 'the npm package should be absent' do
        is_expected.to contain_package('npm').with('ensure' => 'absent')
      end
    end
  end

  context 'when running on Gentoo' do
    let :facts do
      {
        'os' => {
          'family' => 'Gentoo',
          'name' => 'Gentoo'
        }
      }
    end

    # nodejs_package_ensure
    context 'with nodejs_package_ensure set to present' do
      let :params do
        {
          nodejs_package_ensure: 'present'
        }
      end

      it 'the nodejs package should be present' do
        is_expected.to contain_package('net-libs/nodejs').with('ensure' => 'present')
      end
    end

    context 'with nodejs_package_ensure set to absent' do
      let :params do
        {
          nodejs_package_ensure: 'absent'
        }
      end

      it 'the nodejs package should be absent' do
        is_expected.to contain_package('net-libs/nodejs').with('ensure' => 'absent')
      end
    end

    context 'with use_flags set to npm, snapshot' do
      let :params do
        {
          use_flags: %w[npm snapshot]
        }
      end

      it 'the nodejs package should have npm, snapshot use flags' do
        is_expected.to contain_package_use('net-libs/nodejs').with('use' => %w[npm snapshot])
      end
    end
  end

  context 'when running on Amazon Linux 2015.03' do
    let :facts do
      {
        'os' => {
          'family' => 'RedHat',
          'name' => 'Amazon',
          'release' => {
            'full'  => '2015.03',
            'major' => '2015',
            'minor' => '03'
          }
        }
      }
    end

    repo_baseurl        = 'https://rpm.nodesource.com/pub_12.x/el/7/$basearch'
    repo_source_baseurl = 'https://rpm.nodesource.com/pub_12.x/el/7/SRPMS'
    repo_descr          = 'Node.js Packages for Enterprise Linux 7 - $basearch'
    repo_source_descr   = 'Node.js for Enterprise Linux 7 - $basearch - Source'

    # manage_package_repo
    context 'with manage_package_repo set to true' do
      let :default_params do
        {
          manage_package_repo: true
        }
      end

      context 'and repo_class set to ::nodejs::repo::nodesource' do
        let :params do
          default_params.merge!(repo_class: 'nodejs::repo::nodesource')
        end

        it '::nodejs::repo::nodesource should be in the catalog' do
          is_expected.to contain_class('nodejs::repo::nodesource')
        end

        it '::nodejs::repo::nodesource::yum should be in the catalog' do
          is_expected.to contain_class('nodejs::repo::nodesource::yum')
        end

        it 'the nodesource and nodesource-source repos should contain the right description and baseurl' do
          is_expected.to contain_yumrepo('nodesource').with('baseurl' => repo_baseurl,
                                                            'descr'   => repo_descr)

          is_expected.to contain_yumrepo('nodesource-source').with('baseurl' => repo_source_baseurl,
                                                                   'descr'   => repo_source_descr)
        end
      end

      context 'and repo_enable_src set to true' do
        let :params do
          default_params.merge!(repo_enable_src: true)
        end

        it 'the yumrepo resource nodesource-source should contain enabled = 1' do
          is_expected.to contain_yumrepo('nodesource-source').with('enabled' => '1')
        end
      end

      context 'and repo_enable_src set to false' do
        let :params do
          default_params.merge!(repo_enable_src: false)
        end

        it 'the yumrepo resource should contain enabled = 0' do
          is_expected.to contain_yumrepo('nodesource-source').with('enabled' => '0')
        end
      end

      context 'and repo_ensure set to present' do
        let :params do
          default_params.merge!(repo_ensure: 'present')
        end

        it 'the nodesource yum repo files should exist' do
          is_expected.to contain_yumrepo('nodesource')
          is_expected.to contain_yumrepo('nodesource-source')
        end
      end

      context 'and repo_ensure set to absent' do
        let :params do
          default_params.merge!(repo_ensure: 'absent')
        end

        it 'the nodesource yum repo files should not exist' do
          is_expected.to contain_yumrepo('nodesource').with('ensure' => 'absent')
          is_expected.to contain_yumrepo('nodesource-source').with('ensure' => 'absent')
        end
      end

      context 'and repo_proxy set to absent' do
        let :params do
          default_params.merge!(repo_proxy: 'absent')
        end

        it 'the yumrepo resource should contain proxy = absent' do
          is_expected.to contain_yumrepo('nodesource').with('proxy' => 'absent')
          is_expected.to contain_yumrepo('nodesource-source').with('proxy' => 'absent')
        end
      end

      context 'and repo_proxy set to http://proxy.localdomain.com' do
        let :params do
          default_params.merge!(repo_proxy: 'http://proxy.localdomain.com')
        end

        it 'the yumrepo resource should contain proxy = http://proxy.localdomain.com' do
          is_expected.to contain_yumrepo('nodesource').with('proxy' => 'http://proxy.localdomain.com')
          is_expected.to contain_yumrepo('nodesource-source').with('proxy' => 'http://proxy.localdomain.com')
        end
      end

      context 'and repo_proxy_password set to absent' do
        let :params do
          default_params.merge!(repo_proxy_password: 'absent')
        end

        it 'the yumrepo resource should contain proxy_password = absent' do
          is_expected.to contain_yumrepo('nodesource').with('proxy_password' => 'absent')
          is_expected.to contain_yumrepo('nodesource-source').with('proxy_password' => 'absent')
        end
      end

      context 'and repo_proxy_password set to password' do
        let :params do
          default_params.merge!(repo_proxy_password: 'password')
        end

        it 'the yumrepo resource should contain proxy_password = password' do
          is_expected.to contain_yumrepo('nodesource').with('proxy_password' => 'password')
          is_expected.to contain_yumrepo('nodesource-source').with('proxy_password' => 'password')
        end
      end

      context 'and repo_proxy_username set to absent' do
        let :params do
          default_params.merge!(repo_proxy_username: 'absent')
        end

        it 'the yumrepo resource should contain proxy_username = absent' do
          is_expected.to contain_yumrepo('nodesource').with('proxy_username' => 'absent')
          is_expected.to contain_yumrepo('nodesource-source').with('proxy_username' => 'absent')
        end
      end

      context 'and repo_proxy_username set to proxyuser' do
        let :params do
          default_params.merge!(repo_proxy_username: 'proxyuser')
        end

        it 'the yumrepo resource should contain proxy_username = proxyuser' do
          is_expected.to contain_yumrepo('nodesource').with('proxy_username' => 'proxyuser')
          is_expected.to contain_yumrepo('nodesource-source').with('proxy_username' => 'proxyuser')
        end
      end
    end

    context 'with manage_package_repo set to false' do
      let :params do
        {
          manage_package_repo: false
        }
      end

      it '::nodejs::repo::nodesource should not be in the catalog' do
        is_expected.not_to contain_class('::nodejs::repo::nodesource')
      end
    end

    # nodejs_debug_package_ensure
    context 'with nodejs_debug_package_ensure set to present' do
      let :params do
        {
          nodejs_debug_package_ensure: 'present'
        }
      end

      it 'the nodejs package with debugging symbols should be installed' do
        is_expected.to contain_package('nodejs-debuginfo').with('ensure' => 'present')
      end
    end

    context 'with nodejs_debug_package_ensure set to absent' do
      let :params do
        {
          nodejs_debug_package_ensure: 'absent'
        }
      end

      it 'the nodejs package with debugging symbols should not be present' do
        is_expected.to contain_package('nodejs-debuginfo').with('ensure' => 'absent')
      end
    end

    # nodejs_dev_package_ensure
    context 'with nodejs_dev_package_ensure set to present' do
      let :params do
        {
          nodejs_dev_package_ensure: 'present'
        }
      end

      it 'the nodejs development package should be installed' do
        is_expected.to contain_package('nodejs-devel').with('ensure' => 'present')
      end
    end

    context 'with nodejs_dev_package_ensure set to absent' do
      let :params do
        {
          nodejs_dev_package_ensure: 'absent'
        }
      end

      it 'the nodejs development package should not be present' do
        is_expected.to contain_package('nodejs-devel').with('ensure' => 'absent')
      end
    end

    # nodejs_package_ensure
    context 'with nodejs_package_ensure set to present' do
      let :params do
        {
          nodejs_package_ensure: 'present'
        }
      end

      it 'the nodejs package should be present' do
        is_expected.to contain_package('nodejs').with('ensure' => 'present')
      end
    end

    context 'with nodejs_package_ensure set to absent' do
      let :params do
        {
          nodejs_package_ensure: 'absent'
        }
      end

      it 'the nodejs package should be absent' do
        is_expected.to contain_package('nodejs').with('ensure' => 'absent')
      end
    end

    # npm_package_ensure
    context 'with npm_package_ensure set to present' do
      let :params do
        {
          npm_package_ensure: 'present'
        }
      end

      it 'the npm package should be present' do
        is_expected.to contain_package('npm').with('ensure' => 'present')
      end
    end

    context 'with npm_package_ensure set to absent' do
      let :params do
        {
          npm_package_ensure: 'absent'
        }
      end

      it 'the npm package should be absent' do
        is_expected.to contain_package('npm').with('ensure' => 'absent')
      end
    end
  end
end
