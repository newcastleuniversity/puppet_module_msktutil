class msktutil::install inherits msktutil {

  package { 'msktutil':
    ensure => $installed,
    name   => $packagename,
  }

}
