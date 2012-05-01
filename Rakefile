require 'rubygems'
require 'rake'
require 'rspec/core/rake_task'

task :default do
  system("rake -T")
end

task :specs => [:spec]

desc "Run all rspec-puppet tests"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ['--color']
  # ignores fixtures directory.
  t.pattern = 'spec/{classes,defines,unit}/**/*_spec.rb'
end

desc "Build puppet module package"
task :build do
  # This will be deprecated once puppet-module is a face.
  begin
    Gem::Specification.find_by_name('puppet-module')
  rescue Gem::LoadError, NoMethodError
    require 'puppet/face'
    pmod = Puppet::Face['module', :current]
    pmod.build('./')
  end
end

desc "Check puppet manifests with puppet-lint"
task :lint do
  # This requires pull request: https://github.com/rodjek/puppet-lint/pull/81
  system("puppet-lint manifests")
  system("puppet-lint tests")
end
