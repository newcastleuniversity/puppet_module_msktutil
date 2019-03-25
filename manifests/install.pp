# installs and removes msktutil package

class msktutil::install inherits msktutil {

  case $msktutil::ensure {
    'absent', 'no', 'false', false: {
      $install = absent
    }
    default: {
      $install = present
    }
  }

  $msktutil::packages.each | $package | {
    package { $package:
      ensure => $install,
    }
  }

}
