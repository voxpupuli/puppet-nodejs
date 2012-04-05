require 'puppet/provider/package'

Puppet::Type.type(:package).provide :npm, :parent => Puppet::Provider::Package do
  desc "npm is package management for node.js."

  has_feature :versionable
  #has_feature :upgradeable

  commands :npm => 'npm'

  def self.npmlist
    begin
      # ignore any npm output lines to be a bit more robust
      output = npm('list', '--json')
      output = PSON.parse(output.lines.select{ |l| l =~ /^((?!^npm).*)$/}.join("\n"))
      @npmlist = output['dependencies'] || {}
    rescue Exception => e
      Puppet.debug("Error: npm list --json command error #{e.message}")
    end
  end

  def npmlist
    self.class.npmlist
  end

  def self.instances
    @npmlist ||= npmlist
    @npmlist.collect do |k,v|
      new({:name=>k, :ensure=>v['version'], :provider=>'npm'})
    end
  end

  def query
    @npmlist = npmlist

    if @npmlist.has_key?(resource[:name]) and @npmlist[resource[:name]].has_key?('version')
      version = @npmlist[resource[:name]]['version']
      { :ensure => version, :name => resource[:name] }
    else
      { :ensure => :absent, :name => resource[:name] }
    end
  end

  def latest
    if /#{resource[:name]}@([\d\.]+)/ =~ npm('outdated', resource[:name])
      @latest = $1
    else
      @property_hash[:ensure] unless @property_hash[:ensure].is_a? Symbol
    end
  end

  def update
    resource[:ensure] = @latest
    self.install
  end

  def install
    if resource[:ensure].is_a? Symbol
      package = resource[:name]
    else
      package = "#{resource[:name]}@#{resource[:ensure]}"
    end
    npm('install', package)
  end

  def uninstall
    npm('uninstall', resource[:name])
  end

end
