# installs and removes msktutil package

class msktutil::install inherits msktutil {

  case $msktutil::ensure {
    'absent', 'no', false: {
      $install = absent
    }
    default: {
      $install = installed
    }
  }

  $msktutil::packages.each | $package | {
    package { $package:
      ensure => $install,
    }
  }

}
