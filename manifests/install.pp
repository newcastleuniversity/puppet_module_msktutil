class msktutil::install inherits msktutil {

  package { 'msktutil':
    ensure => $ensure,
    name   => $packagename,
  }

}
