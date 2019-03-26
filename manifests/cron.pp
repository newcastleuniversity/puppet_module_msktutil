# manages msktutil keytab rotation

class msktutil::cron inherits msktutil {

  case $msktutil::realcron {
    'no', false: {
      $ensure = absent
    }
    default: {
      $ensure = file
    }
  }
  $msktutil::cronfiles.each | $file, $params | {
    file {
      default:
        ensure => $ensure
      ;
      $file:
        * => $params
    }
  }
}
