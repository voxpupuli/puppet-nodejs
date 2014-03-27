# Class: nodejs::npms
#
# This class enables support for installing both global and local npm packages
# via Hiera. This functionality is auto enabled during the initial nodejs
# module load; this class is not intended to be loaded directly.
#
# See the primary nodejs module documentation for usage and examples.
#
class nodejs::npms {

  # NOTE: hiera_hash does not work as expected in a parameterized class
  #   definition; so we call it here.
  #
  #   http://docs.puppetlabs.com/hiera/1/puppet.html#limitations
  #   https://tickets.puppetlabs.com/browse/HI-118
  #
  $npms = hiera_hash('nodejs::npms', undef)

  if $npms {

    # Install local npms
    if $npms['local'] {
      create_resources('::nodejs::npm', $npms['local'])
    }

    # Install global npms
    if $npms['global'] {
      $defaults = {
        'ensure'    => 'present',
        'provider'  => 'npm',
      }

      create_resources('package', $npms['global'], $defaults)
    }

  }

}

