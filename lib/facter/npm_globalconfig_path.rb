Facter.add('npm_globalconfig_path') do
  setcode 'npm config get globalconfig'
end
