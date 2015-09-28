require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'

begin
  require 'puppet_blacksmith/rake_tasks'
rescue LoadError
end

PuppetLint.configuration.fail_on_warnings = true
PuppetLint.configuration.send('relative')
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.send('disable_class_inherits_from_params_class')
PuppetLint.configuration.send('disable_documentation')
PuppetLint.configuration.send('disable_single_quote_string_with_variables')
PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "pkg/**/*.pp"]

if RUBY_VERSION >= "1.9.0" then
  Blacksmith::RakeTask.new do |t|
    t.build = false # do not build the module nor push it to the Forge
    # just do the tagging [:clean, :tag, :bump_commit]
  end


  desc "Offload release process to Travis."
  task :travis_release => [
    :check_changelog,  # check that the changelog contains an entry for the current release
    :"module:release", # do everything except build / push to forge, travis will do that for us
  ]

  desc "Check Changelog."
  task :check_changelog do
    v = Blacksmith::Modulefile.new.version
    if File.readlines('CHANGELOG.md').grep("Release #{v}").size == 0 then
      fail "Unable to find a CHANGELOG.md entry for the #{v} release."
    end
  end
end
