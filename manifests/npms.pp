# Class: nodejs::npms
#
# PRIVATE CLASS: do not call directly
#
# This class enables support for installing both global and local npm packages
#   via user defined hash param 'npms' to the nodejs class.
#
# See the primary nodejs module documentation for usage and examples.
#
class nodejs::npms(

  $npms       = $::nodejs::npms,
  $hieramerge = $::nodejs::hieramerge

) {

  Class['nodejs'] -> Class[$name]

  # NOTE: hiera_hash does not work as expected in a parameterized class
  #   definition; so we call it here.
  #
  #   http://docs.puppetlabs.com/hiera/1/puppet.html#limitations
  #   https://tickets.puppetlabs.com/browse/HI-118
  #
  if $hieramerge {
    $x_npms = hiera_hash('nodejs::npms', $npms)

  # Fall back to user defined param
  } else {
    $x_npms = $npms
  }

  if $x_npms {
    validate_hash($x_npms)

    # Install any local npms
    if $npms['local'] {
      create_resources('::nodejs::npm', $npms['local'])
    }

    # Install any global npms
    if $npms['global'] {
      $defaults = {
        'ensure'    => 'present',
        'provider'  => 'npm',
      }

      create_resources('package', $npms['global'], $defaults)
    }

  }

}

