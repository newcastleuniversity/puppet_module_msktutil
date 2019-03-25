# manages msktutil keytab rotation

class msktutil::cron inherits msktutil {

  case $msktutil::realcron {
    'false', 'no', false: {
      $msktutil::cronfiles.each | $file, $params | {
        file { $file:
          ensure => absent
        }
      }
    }
    default: {
      $msktutil::cronfiles.each | $file, $params | {
        file { $file:
          * => $params
        }
      }
    }
  }
}
