# frozen_string_literal: true

Facter.add('npm_globalconfig_path') do
  confine { Facter::Core::Execution.which('npm') }

  setcode do
    path = Facter::Core::Execution.execute('npm config get globalconfig', on_fail: nil, timeout: 10)
    path = path.strip if path

    path unless path.nil? || path.empty?
  end
end
