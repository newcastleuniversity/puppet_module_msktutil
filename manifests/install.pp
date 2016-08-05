class msktutil::install (
  $installed   = $::msktutil::params::installed,
  $packagename = $::msktutil::params::packagename,
) inherits msktutil {

  package { 'msktutil':
    ensure => $installed,
    name   => $packagename,
  }

}
