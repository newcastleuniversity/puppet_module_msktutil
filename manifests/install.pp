# installs msktutil package

class msktutil::install inherits msktutil {

  package { 'msktutil':
    ensure => msktutil::ensure",
    name   => msktutil::packagename",
  }

}
