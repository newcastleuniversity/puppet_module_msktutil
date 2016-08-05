class msktutil::install (
  $installed   = $msktutil::param::installed,
  $packagename = $msktutil::param::packagename,
) inherits msktutil {

  package { 'msktutil':
    ensure => $installed,
    name   => $packagename,
  }

}
